//
//  CommonMethods.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class CommonMethods: NSObject {
    class func addShadowToView(containerView:UIView) {
        containerView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 1.2
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.clipsToBounds = false
    }

    class func setCornerRadius(containerView:UIView) {
        containerView.layer.cornerRadius = 1
        containerView.clipsToBounds = true
    }
}
