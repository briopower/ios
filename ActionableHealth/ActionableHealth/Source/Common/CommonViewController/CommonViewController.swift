//
//  CommonViewController.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {
    //MARK:- variables
    var nullCaseView:NullCaseView?
    var showLoading = true
    var showLoginModule = true

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getNavigationController()?.delegate = self
        setNavigationBarBackgroundColor(UIColor.whiteColor())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.dismissKeyboard()
        self.tabBarController?.tabBar.hidden = !NSUserDefaults.isLoggedIn()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.dismissKeyboard()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        if !NSUserDefaults.isLoggedIn() && showLoginModule {
//            UIViewController.presentLoginViewController(true, animated: false)
//        }
    }

    //MARK:  Delegate
    func retryButtonTapped(nullCaseType: NullCaseType, identifier: Int?) {

    }
}





