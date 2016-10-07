//
//  LoginViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

import UIKit

class LoginViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: LoginSignupTableView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var loginButton: UIButton!

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.setupTableView(true)
        CommonMethods.addShadowToView(container)
        CommonMethods.setCornerRadius(loginButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

