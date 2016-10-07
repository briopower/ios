//
//  UIViewController_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

//MARK:- Additional methods
extension UIViewController{
    class func getTopMostViewController() -> UIViewController? {

        if let rootViewCont =  UIApplication.sharedApplication().keyWindow?.rootViewController{
            return self.getTopPresentedViewController(rootViewCont)
        }
        return nil
    }

    class func getTopPresentedViewController(viewControllerObj:UIViewController) -> UIViewController {

        if let presentedViewController = viewControllerObj.presentedViewController {
            return self.getTopPresentedViewController(presentedViewController)
        }else{
            return viewControllerObj
        }
    }
}
