//
//  UIAlertController_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

typealias ActionHandler = (tappedAtIndex:Int?) -> Void

//MARK:- Additional methods
extension UIAlertController{

    class func showAlertOfStyle(alertStyle:UIAlertControllerStyle, Title title:String? = "Error", Message message:String?, OtherButtonTitles otherButtonTitles:[String]? = nil, CancelButtonTitle cancelTitle:String = "Cancel", completion:ActionHandler?){

        UIApplication.sharedApplication().windows.first?.endEditing(true)

        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)

        if otherButtonTitles != nil {
            for count in 0..<otherButtonTitles!.count {
                let  alertAction = UIAlertAction(title: otherButtonTitles![count],
                                                 style: UIAlertActionStyle.Default,
                                                 handler:
                    { (action) in
                        dispatch_async(dispatch_get_main_queue(), {
                            if  completion != nil{
                                completion!(tappedAtIndex:count)
                            }
                        })
                })
                alertController.addAction(alertAction)
            }
        }
        let  alertAction = UIAlertAction(title:cancelTitle, style: UIAlertActionStyle.Cancel,handler:{ (action) in
            dispatch_async(dispatch_get_main_queue(), {
                if  completion != nil{
                    completion!(tappedAtIndex:-1)
                }
            })
        })
        alertController.addAction(alertAction)

        UIViewController.getTopMostViewController()?.presentViewController(alertController, animated: true, completion: nil)

        alertController.view.tintColor = UIColor.getAppThemeColor()

    }

}

