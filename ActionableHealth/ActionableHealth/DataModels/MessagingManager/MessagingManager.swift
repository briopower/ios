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
        closeChatSession()
        FIRAuth.auth()?.signInWithCustomToken(NSUserDefaults.getFirebaseToken(), completion: { (user:FIRUser?, error:NSError?) in
            if let error = error{
                debugPrint("------------FIREBASE SIGNIN TOKEN ISSUE--------------\n\(error)")
            }
            if let code = error?.code{
                if let type = FIRAuthErrorCode(rawValue: code){
                    switch type{
                    case .ErrorCodeNetworkError:
                        self.openChatSession()
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
        AppDelegate.getAppDelegateObject()?.connectToFcm()
    }

    private func configureDatabase() {

        if ref == nil {
            ref = FIRDatabase.database().reference()
        }

        if let handler = _refHandle {
            self.ref?.removeObserverWithHandle(handler)
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
        let objToSend = ["data":["key":userId, "message":message, "type": MessageType.chat.rawValue],
                         "from": NSUserDefaults.getUserId(),
                         "priority": "high",
                         "toUserIds":[userId, NSUserDefaults.getUserId()],
                         "timeStamp": NSDate().timeIntervalInMilliSecs()]

        NetworkClass.sendRequest(URL: Constants.URLs.postMessage, RequestType: .POST, Parameters: objToSend, CompletionHandler: nil)

        self.ref?.child(chanelToObserve).childByAutoId().setValue(objToSend)

        self.ref?.child("channels/\(userId)").childByAutoId().setValue(objToSend)
    }

    private func sendNotification(message:String, userId:String) {
        let objToSend = ["notification":["key":userId, "message":message, "type": MessageType.notification.rawValue],
                         "from": NSUserDefaults.getUserId(),
                         "priority": "high",
                         "toUserIds":[userId]]

        NetworkClass.sendRequest(URL: Constants.URLs.postNotification, RequestType: .POST, Parameters: objToSend, CompletionHandler: nil)
    }
}

//MARK:- Public methods
extension MessagingManager{

    func openChatSession() {
        if FIRAuth.auth()?.currentUser?.uid == NSUserDefaults.getUserId(){
            self.connect()
            refreshToken()
        }else{
            signIn()
        }
    }

    func closeChatSession() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error as NSError {
            debugPrint("------------SIGN OUT ISSUE--------------\n\(error)")
        }
    }

    func send(message:String, userId:String) {
        sendMessage(message, userId: userId)
//        sendNotification(message, userId: userId)
    }
}
