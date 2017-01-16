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
    case chat,chat_attachment, notification
}

class MessagingManager: NSObject {

    //MARK:- Variables
    static let sharedInstance = MessagingManager()
    var ref: FIRDatabaseReference?
    private var _refHandle: FIRDatabaseHandle?
    var isConnectedToDB = false
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
                debugPrint("------------FIREBASE SIGNIN TOKEN ISSUE--------------\n\(error)")
            }
            if let code = error?.code{
                if let type = FIRAuthErrorCode(rawValue: code){
                    switch type{
                    case .ErrorCodeNetworkError:
                        self.openChatSession()
                    case .ErrorCodeInvalidCustomToken:
                        self.refreshToken()
                    default:
                        break
                    }
                }
            }else{
                self.connect()
            }
        })
    }

    private func refreshToken() {
        FIRAuth.auth()?.currentUser?.getTokenForcingRefresh(true, completion: { (token:String?, error:NSError?) in
            if let error = error{
                debugPrint("------------FIREBASE REFRESH TOKEN ISSUE--------------\n\(error)")
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
            self.ref?.child(chanelToObserve).removeObserverWithHandle(handler)
            self.ref?.removeAllObservers()
        }
        if ref == nil {
            ref = FIRDatabase.database().reference()
        }
        // Listen for new messages in the Firebase database
        _refHandle = self.ref?.child(chanelToObserve).observeEventType(.ChildAdded, withBlock:
            { (snapshot:FIRDataSnapshot) in
                self.isConnectedToDB = true
                if let data = snapshot.valueInExportFormat() as? [String:AnyObject]{
                    if let type = MessageType(rawValue: data["data"]?["type"] as? String ?? ""){
                        switch type{
                        case .chat:
                            Messages.saveMessageFor(snapshot.key, value: data)
                        default:
                            break
                        }
                    }
                }
            }, withCancelBlock:
            { (error:NSError) in
                debugPrint("------------DATABASE SYNC ISSUE--------------\n\(error)")
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
        } catch {
            debugPrint("------------SIGN OUT ISSUE--------------\n\(error)")
        }
    }

    func send(message:String, userId:String) {
        sendMessage(message, userId: userId)
        sendNotification(message, userId: userId)
    }

    func connectToFcm() {
        if NSUserDefaults.isLoggedIn() {
            FIRMessaging.messaging().connectWithCompletion { (error:NSError?) in
                if error != nil {
                    debugPrint("Unable to connect with FCM. \(error)")
                } else {
                    debugPrint("Connected to FCM with token: \(FIRInstanceID.instanceID().token())")
                    self.sendNotificationToken()
                }
            }
        }
    }
}
