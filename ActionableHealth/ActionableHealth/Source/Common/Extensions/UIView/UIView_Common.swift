//
//  UIView_Common.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 15/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

//MARK:- Loader Methods
extension UIView{
    func showLaoder(animated:Bool) -> VNProgreessHUD {
        return VNProgreessHUD.showHUDAddedToView(self, Animated: animated)
    }
    
    func hideLoader(animated:Bool) -> Int{
        return VNProgreessHUD.hideAllHudsFromView(self, Animated: animated)
    }
}

//MARK:- Toast Methods
extension UIView{
    class func showToastWith(message:String) {
        UIViewController.getTopMostViewController()?.view.makeToast(message)
    }
}
