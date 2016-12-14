//
//  UIApplication_Common.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 18/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

//MARK:- Additional methods
extension UIApplication{
    class func dismissKeyboard() {
        UIApplication.sharedApplication().windows.first?.endEditing(true)
    }

    class func disableInteraction() {
        if !UIApplication.sharedApplication().isIgnoringInteractionEvents(){
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        }
    }

    class func enableInteraction() {
        if UIApplication.sharedApplication().isIgnoringInteractionEvents(){
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
}

