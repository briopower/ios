//
//  CommonViewController.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK:- variables
    var nullCaseView:NullCaseView?
    var showLoading = true
    var showLoginModule = true
    var loader:VNProgreessHUD?

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if !NSUserDefaults.isLoggedIn(){
            if showLoginModule {
                AppDelegate.getAppDelegateObject()?.addLaunchScreen()
            }
        }
        CommonMethods.addShadowToTabBar(self.tabBarController?.tabBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.enableInteraction()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if getNavigationController()?.viewControllers.count > 1 {
            getNavigationController()?.interactivePopGestureRecognizer?.enabled = true
            getNavigationController()?.interactivePopGestureRecognizer?.delegate = self
        }else{
            getNavigationController()?.interactivePopGestureRecognizer?.enabled = false
            getNavigationController()?.interactivePopGestureRecognizer?.delegate = nil
        }

        if !NSUserDefaults.isLoggedIn() && showLoginModule {
            UIViewController.presentLoginViewController(true, animated: false, Completion: {
                AppDelegate.getAppDelegateObject()?.removeLaunchScreen()
            })
        }else{
            AppDelegate.getAppDelegateObject()?.removeLaunchScreen()
        }
    }

    //MARK:  Delegate
    func retryButtonTapped(nullCaseType: NullCaseType, identifier: Int?) {
        
    }
}





