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

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getNavigationController()?.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.dismissKeyboard()
//        self.tabBarController?.tabBar.hidden = true
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.dismissKeyboard()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    //MARK:  Delegate
    func retryButtonTapped(nullCaseType: NullCaseType, identifier: Int?) {
        
    }
}





