//
//  UIAlertController_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

typealias ActionHandler = (_ tappedAtIndex:Int?) -> Void

//MARK:- Additional methods
extension UIAlertController{

    class func showAlertOfStyle(_ alertStyle:UIAlertControllerStyle = .alert, Title title:String? = "Error", Message message:String?, OtherButtonTitles otherButtonTitles:[String]? = nil, CancelButtonTitle cancelTitle:String = "Cancel", completion:ActionHandler?){

        let alertController = getAlertController(alertStyle, Title: title, Message: message, OtherButtonTitles: otherButtonTitles, CancelButtonTitle: cancelTitle, completion: completion)

        UIViewController.getTopMostViewController()?.present(alertController, animated: true, completion: nil)

        alertController.view.tintColor = UIColor.getAppThemeColor()
    }

    class func getAlertController(_ alertStyle:UIAlertControllerStyle = .alert, Title title:String? = "Error", Message message:String?, OtherButtonTitles otherButtonTitles:[String]? = nil, CancelButtonTitle cancelTitle:String = "Cancel", completion:ActionHandler?) -> UIAlertController {

        UIApplication.shared.windows.first?.endEditing(true)

        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)

        if otherButtonTitles != nil {
            for count in 0..<otherButtonTitles!.count {
                let  alertAction = UIAlertAction(title: otherButtonTitles![count],
                                                 style: UIAlertActionStyle.default,
                                                 handler:
                    { (action) in
                        DispatchQueue.main.async(execute: {
                            if  completion != nil{
                                completion!(count)
                            }
                        })
                })
                alertController.addAction(alertAction)
            }
        }
        let  alertAction = UIAlertAction(title:cancelTitle, style: UIAlertActionStyle.cancel,handler:{ (action) in
            DispatchQueue.main.async(execute: {
                if  completion != nil{
                    completion!(-1)
                }
            })
        })
        alertController.addAction(alertAction)
        
        return alertController
    }
    
}

