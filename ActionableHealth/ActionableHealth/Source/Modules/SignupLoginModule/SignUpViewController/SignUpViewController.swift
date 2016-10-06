//
//  SignUpViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class SignUpViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: LoginSignupTableView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var signupButton: UIButton!
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.setupTableView(false)
        CommonMethods.addShadowToView(container)
        CommonMethods.setCornerRadius(signupButton)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    //MARK:- Button Actions
    @IBAction func loginAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
