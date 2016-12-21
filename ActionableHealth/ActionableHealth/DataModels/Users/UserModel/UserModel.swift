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
    var id:String?
    var userID:String?
    var email:String?
    var firstName:String?
    var lastName:String?
    var name:String?
    var phoneNumber:String?
    var profileImage:String?
    var oldPassword:String?
    var password:String?
    var confirmPassword:String?
    var awhToken:String?
    var hobbies:String?
    var image:UIImage?
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

    func getUpdateProfileDictionary() -> [String : AnyObject] {
        var dict:[String : AnyObject] = [:]
        dict["email"] = email
        dict["firstName"] = firstName
        dict["hobbies"] = hobbies
        dict["lastName"] = lastName
        dict["phone"] = phoneNumber
        dict["userId"] = userID
        return dict
    }

    class func getUserObject(dict:[String : AnyObject]) -> UserModel {
        let model = UserModel()
        model.id = dict["id"] as? String
        model.email = dict["email"] as? String
        model.phoneNumber = dict["phone"] as? String
        model.firstName = dict["firstName"] as? String
        model.userID = dict["userId"] as? String
        model.lastName = dict["lastName"] as? String
        model.profileImage = dict["userProfileURL"] as? String
        model.name = Contact.getNameForContact(model.userID ?? "")
        return model
    }

    class func getCurrentUser() -> UserModel {
        let model = UserModel()
        if let userDict = NSUserDefaults.getUser() as? [String : AnyObject] {
            let dict = userDict["user"] as? [String : AnyObject] ?? userDict
            model.id = dict["id"] as? String
            model.email = dict["email"] as? String
            model.phoneNumber = dict["phone"] as? String
            model.firstName = dict["firstName"] as? String
            model.lastName = dict["lastName"] as? String
            model.hobbies = dict["hobbies"] as? String
            model.userID = dict["userId"] as? String
            model.profileImage = dict["userProfileURL"] as? String
        }
        return model
    }
}
