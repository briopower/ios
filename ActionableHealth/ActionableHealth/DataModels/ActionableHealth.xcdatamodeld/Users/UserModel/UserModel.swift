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
    var userID = ""
    var email = ""
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var profileImage = ""
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
}