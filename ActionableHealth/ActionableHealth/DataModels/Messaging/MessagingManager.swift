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

    deinit {
        if let handler = _refHandle{
            self.ref?.child("channels").removeObserverWithHandle(handler)
        }
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
        self.ref?.child("channels").observeSingleEventOfType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
            print(snapshot)
        })
    }
}
