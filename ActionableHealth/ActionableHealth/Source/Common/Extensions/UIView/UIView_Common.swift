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
    func showLoader(animated:Bool) -> VNProgreessHUD {
        return VNProgreessHUD.showHUDAddedToView(self, Animated: animated)
    }
    
    func hideLoader(animated:Bool) -> Int{
        return VNProgreessHUD.hideAllHudsFromView(self, Animated: animated)
    }
}

//MARK:- Toast Methods
extension UIView{
    class func showToast(message:String, theme:Theme) {
        let messageView = MessageView.viewFromNib(layout: .StatusLine)
        messageView.configureTheme(theme)
        messageView.configureContent(body: message)
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = SwiftMessages.PresentationContext.Window(windowLevel:UIWindowLevelNormal)
        statusConfig.preferredStatusBarStyle = UIStatusBarStyle.LightContent
        SwiftMessages.show(config: statusConfig, view: messageView)
    }
}
