//
//  UserModel.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 18/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    //MARK:- Variables
    var id = ""
    var userID = ""
    var email = ""
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var profileImage = ""
    var oldPassword = ""
    var password = ""
    var confirmPassword = ""
}

//MARK:- Additional methods
extension UserModel{
    func getSignupDictionary() -> [String : String]
    {
        var dict:[String : String] = [:]
        dict["email"] = self.email
        dict["firstName"] = self.firstName
        dict["lastName"] = self.lastName
        dict["password"] = self.password
        dict["phone"] = self.phoneNumber
        return dict
    }

    func getLoginDictionary() -> [String : String] {
        var dict:[String : String] = [:]
        dict["userId"] = self.email
        dict["password"] = self.password
        return dict
    }
    
    func getUpdatePasswordDictionary() -> [String : String] {
        var dict:[String : String] = [:]
        dict["newPassword"] = self.password
        dict["oldPassword"] = self.oldPassword
        if let userDict = NSUserDefaults.getUser() as? [String : AnyObject]  {
            dict["userId"] = userDict["email"] as? String
        }
        return dict
    }

    class func getUserObject(dict:[String : AnyObject]) -> UserModel {
        let model = UserModel()
        model.id = dict["id"] as? String ?? ""
        model.phoneNumber = dict["email"] as? String ?? ""
        model.firstName = dict["firstName"] as? String ?? ""
        model.userID = dict["userId"] as? String ?? ""
        model.lastName = dict["lastName"] as? String ?? ""
        model.profileImage = dict["userProfileURL"] as? String ?? ""
        return model
    }
}
