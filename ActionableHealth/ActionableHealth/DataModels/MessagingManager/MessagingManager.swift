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
        self.ref?.child(chanelToObserve).removeAllObservers()
    }
}

//MARK:- Additional methods
extension MessagingManager{
    func openChatSession() {
        FIRAuth.auth()?.signInWithCustomToken(NSUserDefaults.getFirebaseToken(), completion: { (user:FIRUser?, error:NSError?) in
            self.configureDatabase()
        })
    }

    func closeChatSession() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }

    func configureDatabase() {
        if ref == nil{
            ref = FIRDatabase.database().reference()
        }

        // Listen for new messages in the Firebase database
        self.ref?.child(chanelToObserve).observeEventType(.ChildAdded, withBlock:
            { (snapshot:FIRDataSnapshot) in
                print(snapshot.valueInExportFormat())
            }, withCancelBlock:
            { (error:NSError) in
                print(error)
        })

        self.ref?.child(chanelToObserve).observeEventType(.ChildChanged, withBlock:
            { (snapshot:FIRDataSnapshot) in
                print(snapshot.valueInExportFormat())
            }, withCancelBlock:
            { (error:NSError) in
                print(error)
        })
    }

    func send(message:String, userId:String) {
        self.ref?.child("channels/\(userId)").child("8882345715").child("\(Int(NSDate().timeIntervalInMilliSecs()))").updateChildValues(["message":NSDate().longString])
    }
}
