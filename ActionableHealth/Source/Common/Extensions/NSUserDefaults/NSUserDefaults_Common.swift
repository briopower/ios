//
//  NSUserDefaults_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

private let userDefault = UserDefaults.standard

//MARK:- Additional methods
extension UserDefaults{
    class func clear() {
        if let bundleId = Bundle.main.bundleIdentifier{
            UserDefaults.standard.removePersistentDomain(forName: bundleId)
        }
    }

    class func getDeviceToken() -> Data? {
        return userDefault.value(forKey: "deviceTokenPush_Key") as? Data
    }

    class func setDeviceToken(_ token:Data) {
        userDefault.setValue(token, forKey: "deviceTokenPush_Key")
        userDefault.synchronize()
    }

    class func getUserToken() -> String {
        return userDefault.value(forKey: "UserToken_Key") as? String ?? ""
    }

    class func setUserToken(_ token:String) {
        userDefault.setValue(token, forKey: "UserToken_Key")
        userDefault.synchronize()
    }

    class func getFirebaseToken() -> String {
        return userDefault.value(forKey: "UserFirebaseToken_Key") as? String ?? ""
    }

    class func setFirebaseToken(_ token:String) {
        userDefault.setValue(token, forKey: "UserFirebaseToken_Key")
        userDefault.synchronize()
    }


    class func isLoggedIn() -> Bool {
        return userDefault.bool(forKey: "userLoggedIn")

    }
    
    class func isDisclaimerWatched() -> Bool {
        return userDefault.bool(forKey: "disclaimerWatched")
        
    }
    
    class func setDisclaimerWatched(_ watched:Bool){
        userDefault.set(watched, forKey: "disclaimerWatched")
        userDefault.synchronize()
    }

    class func setLoggedIn(_ loggedIn:Bool) {
        userDefault.set(loggedIn, forKey: "userLoggedIn")
        userDefault.synchronize()
    }

    class func saveUser(_ obj:AnyObject?) {
        if let dict = obj {
            if let token = dict["ahwToken"] as? String {
                setLoggedIn(true)
                setUserToken(token)
            }
            if let token = dict["firebaseToken"] as? String {
                setFirebaseToken(token)
            }
            userDefault.set(NSKeyedArchiver.archivedData(withRootObject: dict), forKey: "currentUser")
        }
    }
    class func getUser() -> AnyObject? {

        if let data = userDefault.object(forKey: "currentUser") as? Data {
            let returnObj = NSKeyedUnarchiver.unarchiveObject(with: data)
            return returnObj as AnyObject?
        }
        return false as AnyObject?
    }

    class func getUserId() -> String {
        if let userDict = UserDefaults.getUser() as? [String : AnyObject]  {
            return  userDict["user"]?["userId"] as? String ?? userDict["userId"] as? String ?? ""
        }
        return ""
    }
}
