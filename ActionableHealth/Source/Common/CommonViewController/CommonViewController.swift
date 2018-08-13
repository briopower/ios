//
//  CommonViewController.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CommonViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK:- variables
    var nullCaseView:NullCaseView?
    var showLoading = true
    var showLoginModule = true
    var loader:VNProgreessHUD?
    var isDisclaimerPresented : Bool = false

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.isLoggedIn(){
            if showLoginModule {
                (UIApplication.shared.delegate as? AppDelegate)?.addLaunchScreen()
            }
        }
        CommonMethods.addShadowToTabBar(self.tabBarController?.tabBar)
        setNavigationBarBackgroundColor(UIColor.white)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.enableInteraction()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if getNavigationController()?.viewControllers.count > 1 {
            getNavigationController()?.interactivePopGestureRecognizer?.isEnabled = true
            getNavigationController()?.interactivePopGestureRecognizer?.delegate = self
        }else{
            getNavigationController()?.interactivePopGestureRecognizer?.isEnabled = false
            getNavigationController()?.interactivePopGestureRecognizer?.delegate = nil
        }

        if !UserDefaults.isLoggedIn() && showLoginModule {
            UIViewController.presentLoginViewController(true, animated: false, Completion: {
                if UserDefaults.isDisclaimerWatched(){
                    (UIApplication.shared.delegate as? AppDelegate)?.removeLaunchScreen()
                }
            })
        }else{
            if UserDefaults.isDisclaimerWatched(){
                (UIApplication.shared.delegate as? AppDelegate)?.removeLaunchScreen()
            }
        }
    }

    //MARK:  Delegate
    func retryButtonTapped(_ nullCaseType: NullCaseType, identifier: Int?) {
        
    }
}





