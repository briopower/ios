//
//  MessagingManager.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
import Firebase

enum MessageType: String {
    case chat,chat_attachment, notification, comment
}

class MessagingManager: NSObject {

    //MARK:- Variables
    static let sharedInstance = MessagingManager()
    let messageReceived = "messageReceivedNotification"
    var ref: FIRDatabaseReference?
    private var _refHandle: FIRDatabaseHandle?
    var chanelToObserve:String{
        get{
            return "channels/\(NSUserDefaults.getUserId())"
        }
    }
}

//MARK:- Private methods
extension MessagingManager{
    private func signIn() {
        FIRAuth.auth()?.signInWithCustomToken(NSUserDefaults.getFirebaseToken(), completion: { (user:FIRUser?, error:NSError?) in
            if let error = error{
                debugPrint("------------FIREBASE SIGNIN TOKEN ISSUE--------------\(error)")
                if let type = FIRAuthErrorCode(rawValue: error.code){
                    switch type{
                    case .ErrorCodeNetworkError:
                        self.openChatSession()
                    default:
                        self.refreshToken()
                    }
                }
            }

            self.connect()
        })
    }

    private func refreshToken() {
        FIRAuth.auth()?.currentUser?.getTokenForcingRefresh(true, completion: { (token:String?, error:NSError?) in
            if let error = error{
                debugPrint("------------FIREBASE REFRESH TOKEN ISSUE--------------\(error)")
                self.signIn()
            }else if let tkn = token{
                NSUserDefaults.setFirebaseToken(tkn)
                self.connect()
            }
        })
    }

    private func connect() {
        self.configureDatabase()
        connectToFcm()
    }

    private func configureDatabase() {

        if let handler = _refHandle {
            ref?.child(chanelToObserve).removeObserverWithHandle(handler)
            ref?.removeAllObservers()
            ref = nil
        }

        if ref == nil {
            ref = FIRDatabase.database().reference()
        }

        // Listen for new messages in the Firebase database
        _refHandle = self.ref?.child(chanelToObserve).observeEventType(.ChildAdded, withBlock:
            { (snapshot:FIRDataSnapshot) in
                if let data = snapshot.valueInExportFormat() as? [String:AnyObject]{
                    if let type = MessageType(rawValue: data["data"]?["type"] as? String ?? ""){
                        switch type{
                        case .chat:
                            Messages.saveMessageFor(snapshot.key, value: data)
                            NSNotificationCenter.defaultCenter().postNotificationName(self.messageReceived, object: data)
                        default:
                            break
                        }
                    }
                }
            }, withCancelBlock:
            { (error:NSError) in
                debugPrint("------------DATABASE SYNC ISSUE MESSAGING--------------\(error)")
                self.refreshToken()
        })
    }


    private func sendMessage(message:String, userId:String) {
        let objToSend:[String:AnyObject] = ["data":["key":userId, "message":message, "type": MessageType.chat.rawValue],
                                            "from": NSUserDefaults.getUserId(),
                                            "priority": "high",
                                            "toUserIds":[userId],
                                            "timeStamp": NSDate().timeIntervalInMilliSecs()]

        NetworkClass.sendRequest(URL: Constants.URLs.postMessage, RequestType: .POST, ResponseType: ExpectedResponseType.NONE, Parameters: objToSend){ (status, responseObj, error, statusCode) in
            debugPrint("sendMessage \(statusCode)")
        }


        self.ref?.child(chanelToObserve).childByAutoId().setValue(objToSend)

        self.ref?.child("channels/\(userId)").childByAutoId().setValue(objToSend)
    }

    private func sendNotification(message:String, userId:String) {
        let objToSend:[String:AnyObject] = ["data":["key":userId, "message":message, "type": MessageType.chat.rawValue],
                                            "notification":["title":"New Message", "body":message, "icon": ""],
                                            "from": NSUserDefaults.getUserId(),
                                            "priority": "high",
                                            "toUserIds":[userId]]

        NetworkClass.sendRequest(URL: Constants.URLs.postNotification, RequestType: .POST, ResponseType: ExpectedResponseType.NONE, Parameters: objToSend){ (status, responseObj, error, statusCode) in
            debugPrint("sendNotification \(statusCode)")
        }

    }

    private func sendNotificationToken() {
        if let refreshedToken = FIRInstanceID.instanceID().token(), let userId = FIRAuth.auth()?.currentUser?.uid{
            let objToSend = ["deviceToken": refreshedToken, "userId":userId]
            NetworkClass.sendRequest(URL: Constants.URLs.sendToken, RequestType: .POST, ResponseType: .NONE, Parameters: objToSend){ (status, responseObj, error, statusCode) in
                debugPrint("sendNotificationToken \(statusCode)")
            }
        }
    }
}

//MARK:- Public methods
extension MessagingManager{

    func openChatSession() {
        FIRApp.configure()
        if FIRAuth.auth()?.currentUser?.uid == NSUserDefaults.getUserId(){
            self.configureDatabase()
            refreshToken()
        }else{
            signIn()
        }
    }

    func closeChatSession() {
        do {
            try FIRAuth.auth()?.signOut()
            let secItemClasses = [kSecClassGenericPassword,
                                  kSecClassInternetPassword,
                                  kSecClassCertificate,
                                  kSecClassKey,
                                  kSecClassIdentity]
            for secItemClass in secItemClasses {
                let dictionary = [kSecClass as String:secItemClass]
                SecItemDelete(dictionary)
            }
        } catch {
            debugPrint("------------SIGN OUT ISSUE--------------\(error)")
        }
    }

    func send(message:String, userId:String) {
        sendMessage(message, userId: userId)
        sendNotification(message, userId: userId)
    }

    func connectToFcm() {
        if NSUserDefaults.isLoggedIn() {
            if let _ = FIRInstanceID.instanceID().token() {
                // Connect to FCM since connection may have failed when attempted before having a token.
                FIRMessaging.messaging().disconnect()
                FIRMessaging.messaging().connectWithCompletion { (error:NSError?) in
                    if error != nil {
                        debugPrint("Unable to connect with FCM. \(error)")
                        self.connectToFcm()
                    } else {
                        debugPrint("Connected to FCM with token: \(FIRInstanceID.instanceID().token())")
                        self.sendNotificationToken()
                    }
                }
            }
            
        }
    }
}
