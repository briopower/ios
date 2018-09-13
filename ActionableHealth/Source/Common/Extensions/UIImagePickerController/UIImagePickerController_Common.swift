//
//  UIImagePickerController_Common.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 16/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

extension UIImagePickerController{
    class func showPickerWithDelegate(_ delegate:(UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {

        DispatchQueue.main.async(execute: {
            let buttonTitles =  UIImagePickerController.isSourceTypeAvailable(.camera) ? ["Camera", "Photo Library"] : ["Photo Library"]
            let pickerController = UIImagePickerController()
            pickerController.allowsEditing = true
            pickerController.delegate = delegate

            UIAlertController.showAlertOfStyle(.actionSheet, Title: "Select image source", Message: nil, OtherButtonTitles: buttonTitles, CancelButtonTitle: "Cancel") { (tappedAtIndex) in
                if tappedAtIndex == 0{
                    if UIImagePickerController.isSourceTypeAvailable(.camera){
                        pickerController.sourceType = .camera
                    }else{
                        pickerController.sourceType = .photoLibrary
                    }
                }else if tappedAtIndex == 1{
                    pickerController.sourceType = .photoLibrary
                }

                if tappedAtIndex != -1{
                    DispatchQueue.main.async(execute: {
                        UIViewController.getTopMostViewController()?.present(pickerController, animated: true, completion: {
                            pickerController.delegate = delegate
                        })
                    })
                }
            }
        })
    }
}
