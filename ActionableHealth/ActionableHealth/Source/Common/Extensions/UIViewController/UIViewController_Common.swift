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

    class func presentLoginViewController(shouldResetData:Bool = false, animated:Bool = true, Completion complete:(()-> Void)? = nil){
        if let viewCont = getTopMostViewController() as? UINavigationController {
            if viewCont.viewControllers.count > 0{
                if let viewCont1 = UIStoryboard(name: Constants.Storyboard.LoginStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateInitialViewController() as? UINavigationController {
                    viewCont.presentViewController(viewCont1, animated: animated, completion: {
                        if shouldResetData{
                            NSUserDefaults.clear()
                            if let tabBarCont = viewCont.viewControllers[0] as? UITabBarController{
                                tabBarCont.selectedIndex = 0
                                if let homeView = tabBarCont.selectedViewController as?
                                    HomeViewController{
                                    homeView.reset()
                                }
                            }
                        }
                        complete?()
                    })
                }
            }
        }
    }
}
