//
//  MessagingManager.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseMessaging

enum MessageType: String {
    case chat,chat_attachment, notification, comment
}

class MessagingManager: NSObject {

    //MARK:- Variables
    static let sharedInstance = MessagingManager()
    let messageReceived = "messageReceivedNotification"
    var isConnected = true
    var ref: DatabaseReference?
    fileprivate var _refHandle: DatabaseHandle?
    var chattingWithPerson:String?

    var chanelToObserve:String{
        get{
            return "channels/\(UserDefaults.getUserId())"
        }
    }
}

//MARK:- Private methods
extension MessagingManager{
    fileprivate func signIn() {
        Auth.auth().signIn(withCustomToken: UserDefaults.getFirebaseToken()) { (authDataResult: AuthDataResult?, error: Error?) in
            if let error = error{
                self.isConnected = false
                debugPrint("------------FIREBASE SIGNIN TOKEN ISSUE--------------\(error)")
                if let type = AuthErrorCode(rawValue: (error as NSError).code){
                    switch type{
                    case .networkError:
                        self.openChatSession()
                    default:
                        self.refreshToken()
                    }
                }
            }
           self.connect()
        }
    }

    fileprivate func refreshToken() {
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (token: String?, error: Error?) in
            if let error = error{
                self.isConnected = false
                debugPrint("------------FIREBASE REFRESH TOKEN ISSUE--------------\(error)")
                self.signIn()
            }else if let tkn = token{
                self.isConnected = true
                UserDefaults.setFirebaseToken(tkn)
                self.connect()
            }
        })
    }

    fileprivate func connect() {
        self.configureDatabase()
        connectToFcm()
    }

    fileprivate func configureDatabase() {

        if let handler = _refHandle {
            ref?.child(chanelToObserve).removeObserver(withHandle: handler)
            ref?.removeAllObservers()
            ref = nil
        }

        if ref == nil {
            ref = Database.database().reference()
        }

        // Listen for new messages in the Firebase database
        _refHandle = self.ref?.child(chanelToObserve).observe(.childAdded, with:
            { (snapshot:DataSnapshot) in
                self.isConnected = true
                if let data = snapshot.valueInExportFormat() as? [String:AnyObject]{
                    if let type = MessageType(rawValue: data["data"]?["type"] as? String ?? ""){
                        switch type{
                        case .chat:
                            Messages.saveMessageFor(snapshot.key, value: data)
                            NotificationCenter.default.post(name: Notification.Name(rawValue: self.messageReceived), object: data)
                        default:
                            break
                        }
                    }
                }
            }, withCancel:
            { (error:Error) in
                self.isConnected = false
                debugPrint("------------DATABASE SYNC ISSUE MESSAGING--------------\(error)")
                self.refreshToken()
                } )
    }


    fileprivate func sendMessage(_ message:String, userId:String, trackName:String?) {
        let objToSend:[String:Any] = ["data":["key":userId, "message":message, "type": MessageType.chat.rawValue],
                                            "from": UserDefaults.getUserId(),
                                            "priority": "high",
                                            "toUserIds":[userId],
                                            "timeStamp": Date().timeIntervalInMilliSecs(),
                                            "lastTrackName": trackName ?? ""]

        NetworkClass.sendRequest(URL: Constants.URLs.postMessage, RequestType: .post, ResponseType: ExpectedResponseType.none, Parameters: objToSend as AnyObject){ (status, responseObj, error, statusCode) in
            debugPrint("sendMessage \(statusCode)")
        }


        self.ref?.child(chanelToObserve).childByAutoId().setValue(objToSend)

        self.ref?.child("channels/\(userId)").childByAutoId().setValue(objToSend)
    }

    fileprivate func sendNotification(_ message:String, userId:String) {
        let objToSend:[String:AnyObject] = ["data":["key":UserDefaults.getUserId(), "message":message, "type": MessageType.chat.rawValue] as AnyObject,
                                            "notification":["title":"New Message", "body":message, "icon": ""] as AnyObject,
                                            "from": UserDefaults.getUserId() as AnyObject,
                                            "priority": "high" as AnyObject,
                                            "toUserIds":[userId] as AnyObject]

        NetworkClass.sendRequest(URL: Constants.URLs.postNotification, RequestType: .post, ResponseType: ExpectedResponseType.none, Parameters: objToSend as AnyObject){ (status, responseObj, error, statusCode) in
            debugPrint("sendNotification \(statusCode)")
        }

    }

    fileprivate func sendNotificationToken() {
        if let refreshedToken = InstanceID.instanceID().token(), let userId = Auth.auth().currentUser?.uid{
            let objToSend = ["deviceToken": refreshedToken, "userId":userId]
            NetworkClass.sendRequest(URL: Constants.URLs.sendToken, RequestType: .post, ResponseType: .none, Parameters: objToSend as AnyObject){ (status, responseObj, error, statusCode) in
                debugPrint("sendNotificationToken \(statusCode)")
            }
        }
    }
}

//MARK:- Public methods
extension MessagingManager{

    func openChatSession() {
        //FirebaseApp.configure()
        if Auth.auth().currentUser?.uid == UserDefaults.getUserId(){
            self.configureDatabase()
            refreshToken()
        }else{
            signIn()
        }
    }

    func closeChatSession() {
        do {
            try Auth.auth().signOut()
            let secItemClasses = [kSecClassGenericPassword,
                                  kSecClassInternetPassword,
                                  kSecClassCertificate,
                                  kSecClassKey,
                                  kSecClassIdentity]
            for secItemClass in secItemClasses {
                let dictionary = [kSecClass as String:secItemClass]
                SecItemDelete(dictionary as CFDictionary)
            }
        } catch {
            debugPrint("------------SIGN OUT ISSUE--------------\(error)")
        }
    }

    func send(_ message:String, userId:String, trackName:String?) {
        sendMessage(message, userId: userId, trackName:trackName)
        sendNotification(message, userId: userId)
    }

    func connectToFcm() {
        if UserDefaults.isLoggedIn() {
            InstanceID.instanceID().instanceID(handler: { (result: InstanceIDResult?, error: Error?) in
                if let _ = result?.token{
                    Messaging.messaging().shouldEstablishDirectChannel = false
                    Messaging.messaging().shouldEstablishDirectChannel = true
                    
                }
            })
            
//            if let _ = InstanceID.instanceID().token() {
//                // Connect to FCM since connection may have failed when attempted before having a token.
//                Messaging.messaging().disconnect()
//                Messaging.messaging().connect { (error:Error?) in
//                    if error != nil {
//                        self.isConnected = false
//                        debugPrint("Unable to connect with FCM. \(error)")
//                        self.connectToFcm()
//                    } else {
//                        self.isConnected = true
//                        debugPrint("Connected to FCM with token: \(InstanceID.instanceID().token())")
//                        self.sendNotificationToken()
//                    }
//                    } as! MessagingConnectCompletion
//            }

        }
    }

    func receivedPushNotification(_ userInfo: [AnyHashable: Any]) {
        // Let FCM know about the message for analytics etc.`
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let type = MessageType(rawValue: userInfo["type"] as? String ?? "") {
            switch type {
            case .chat:
                if let from = userInfo["key"] as? String {
                    if let message = userInfo["message"] as? String {
                        let person = Person.getPersonWith(from)
                        switch UIApplication.shared.applicationState {
                        case .active:
                            if from != chattingWithPerson {
                                let personName = person?.personName ?? from
                                UIView.showToast("\(personName) : \(message)", theme: Theme.success)
                            }
                        case .inactive:
                            if let viewCont = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.MessagingStoryboard.messagingView) as? MessagingViewController, let person = person{
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
