//
//  UIImagePickerController_Common.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 16/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

extension UIImagePickerController{
    class func showPickerWithDelegate(delegate:protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>?) {

        dispatch_async(dispatch_get_main_queue(), {
            let buttonTitles =  UIImagePickerController.isSourceTypeAvailable(.Camera) ? ["Camera", "Photo Library"] : ["Photo Library"]
            let pickerController = UIImagePickerController()
            pickerController.allowsEditing = true
            pickerController.delegate = delegate

            UIAlertController.showAlertOfStyle(.ActionSheet, Title: "Select image source", Message: nil, OtherButtonTitles: buttonTitles, CancelButtonTitle: "Cancel") { (tappedAtIndex) in
                if tappedAtIndex == 0{
                    if UIImagePickerController.isSourceTypeAvailable(.Camera){
                        pickerController.sourceType = .Camera
                    }else{
                        pickerController.sourceType = .PhotoLibrary
                    }
                }else if tappedAtIndex == 1{
                    pickerController.sourceType = .PhotoLibrary
                }

                if tappedAtIndex != -1{
                    dispatch_async(dispatch_get_main_queue(), {
                        UIViewController.getTopMostViewController()?.presentViewController(pickerController, animated: true, completion: {
                            pickerController.delegate = delegate
                        })
                    })
                }
            }
        })
    }
}
