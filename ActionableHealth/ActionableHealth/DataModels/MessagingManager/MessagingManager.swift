//
//  MessagingManager.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
import Firebase

enum PresenceType:String {
    case online, offline, typing
}

class MessagingManager: NSObject {

    //MARK:- Variables
    static let sharedInstance = MessagingManager()
    var ref: FIRDatabaseReference?
    private var _refHandle: FIRDatabaseHandle?
    var chanelToObserve:String{
        get{
            return "channels/\(NSUserDefaults.getUserId())"
        }
    }

    deinit {
        removeObservers()
    }
}

//MARK:- Additional methods
extension MessagingManager{
    func openChatSession() {
        FIRAuth.auth()?.signInWithCustomToken(NSUserDefaults.getFirebaseToken(), completion: { (user:FIRUser?, error:NSError?) in
            if let code = error?.code{
                debugPrint(error)
                if let type = FIRAuthErrorCode(rawValue: code){
                    switch type{
                    case .ErrorCodeNetworkError:
                        self.openChatSession()
                    default:
                        break
                    }
                }
            }else{
                self.configureDatabase()

            }
        })
    }

    func closeChatSession() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            debugPrint("Error signing out: \(signOutError.localizedDescription)")
        }
    }

    func configureDatabase() {
        if ref == nil{
            ref = FIRDatabase.database().reference()
        }

        // Listen for new messages in the Firebase database
        self.ref?.child(chanelToObserve).observeEventType(.ChildAdded, withBlock:
            { (snapshot:FIRDataSnapshot) in
                if let data = snapshot.valueInExportFormat() as? [String:AnyObject]{
                    if let type = data["data"]?["type"] as? String{
                        switch type{
                        case "chat":
                            Messages.saveMessageFor(snapshot.key, value: data)
                        default:
                            break
                        }
                    }
                }
            }, withCancelBlock:
            { (error:NSError) in
                debugPrint(error)
        })
    }
    func removeObservers() {
        self.ref?.child(chanelToObserve).removeAllObservers()
    }
    func send(message:String, userId:String) {
        let objToSend = ["data":["key":userId, "message":message, "type": "chat"],
                         "from": NSUserDefaults.getUserId(),
                         "priority": "high",
                         "toUserIds":[userId, NSUserDefaults.getUserId()]]

        NetworkClass.sendRequest(URL: Constants.URLs.postMessage, RequestType: .POST, ResponseType: .JSON, Parameters: objToSend, Headers: nil) {
            (status, responseObj, error, statusCode) in
        }
    }
}
