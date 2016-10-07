//
//  NSUserDefaults_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

let userDefault = NSUserDefaults.standardUserDefaults()

//MARK:- Additional methods
extension NSUserDefaults{
    class func clear() {
        if let bundleId = NSBundle.mainBundle().bundleIdentifier{
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(bundleId)
        }
    }

    class func getDeviceToken() -> NSData? {
        return userDefault.valueForKey("deviceTokenPush_Key") as? NSData
    }

    class func setDeviceToken(token:NSData) {
        userDefault.setValue(token, forKey: "deviceTokenPush_Key")
        userDefault.synchronize()
    }

    class func isLoggedIn() -> Bool {
        return userDefault.boolForKey("userLoggedIn")
    }

    class func setLoggedIn(loggedIn:Bool) {
        userDefault.setBool(loggedIn, forKey: "userLoggedIn")
        userDefault.synchronize()
    }
}