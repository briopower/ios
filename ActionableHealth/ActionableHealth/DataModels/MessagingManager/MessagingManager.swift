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
    var isConnected = true
    var ref: FIRDatabaseReference?
    private var _refHandle: FIRDatabaseHandle?
    var chattingWithPerson:String?

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
                self.isConnected = false
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
                self.isConnected = false
                debugPrint("------------FIREBASE REFRESH TOKEN ISSUE--------------\(error)")
                self.signIn()
            }else if let tkn = token{
                self.isConnected = true
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
                self.isConnected = true
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
                self.isConnected = false
                debugPrint("------------DATABASE SYNC ISSUE MESSAGING--------------\(error)")
                self.refreshToken()
        })
    }


    private func sendMessage(message:String, userId:String, trackName:String?) {
        let objToSend:[String:AnyObject] = ["data":["key":userId, "message":message, "type": MessageType.chat.rawValue],
                                            "from": NSUserDefaults.getUserId(),
                                            "priority": "high",
                                            "toUserIds":[userId],
                                            "timeStamp": NSDate().timeIntervalInMilliSecs(),
                                            "lastTrackName": trackName ?? ""]

        NetworkClass.sendRequest(URL: Constants.URLs.postMessage, RequestType: .POST, ResponseType: ExpectedResponseType.NONE, Parameters: objToSend){ (status, responseObj, error, statusCode) in
            debugPrint("sendMessage \(statusCode)")
        }


        self.ref?.child(chanelToObserve).childByAutoId().setValue(objToSend)

        self.ref?.child("channels/\(userId)").childByAutoId().setValue(objToSend)
    }

    private func sendNotification(message:String, userId:String) {
        let objToSend:[String:AnyObject] = ["data":["key":NSUserDefaults.getUserId(), "message":message, "type": MessageType.chat.rawValue],
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

    func send(message:String, userId:String, trackName:String?) {
        sendMessage(message, userId: userId, trackName:trackName)
        sendNotification(message, userId: userId)
    }

    func connectToFcm() {
        if NSUserDefaults.isLoggedIn() {
            if let _ = FIRInstanceID.instanceID().token() {
                // Connect to FCM since connection may have failed when attempted before having a token.
                FIRMessaging.messaging().disconnect()
                FIRMessaging.messaging().connectWithCompletion { (error:NSError?) in
                    if error != nil {
                        self.isConnected = false
                        debugPrint("Unable to connect with FCM. \(error)")
                        self.connectToFcm()
                    } else {
                        self.isConnected = true
                        debugPrint("Connected to FCM with token: \(FIRInstanceID.instanceID().token())")
                        self.sendNotificationToken()
                    }
                }
            }

        }
    }

    func receivedPushNotification(userInfo: [NSObject : AnyObject]) {
        // Let FCM know about the message for analytics etc.`
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        
        if let type = MessageType(rawValue: userInfo["type"] as? String ?? "") {
            switch type {
            case .chat:
                if let from = userInfo["key"] as? String {
                    if let message = userInfo["message"] as? String {
                        let person = Person.getPersonWith(from)
                        switch UIApplication.sharedApplication().applicationState {
                        case .Active:
                            if from != chattingWithPerson {
                                let personName = person?.personName ?? from
                                UIView.showToast("\(personName) : \(message)", theme: Theme.Success)
                            }
                        case .Inactive:
                            if let viewCont = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.MessagingStoryboard.messagingView) as? MessagingViewController, let person = person{
                                viewCont.personObj = person
                                AppDelegate.getAppDelegateObject()?.window?.rootViewController?.getNavigationController()?.pushViewController(viewCont, animated: false)
                            }
                        default:
                            break
                        }
                    }
                }
            default:
                break
            }
        }
        
        
    }
}