//
//  LoginViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class LoginViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: LoginSignupTableView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var loginButton: UIButton!

    //MARK:- Variables
    let currentUser = UserModel()

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

//MARK:- Additional Methods
extension LoginViewController{
    func setupView() {
        tblView.setupTableView(true, user: currentUser)
        tblView.loginSignupTblViewDelegate = self
        CommonMethods.addShadowToView(container)
        CommonMethods.setCornerRadius(loginButton)
    }

    func checkData() -> Bool {
        if currentUser.email.length() == 0 {
            UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Enter email", completion: nil)
            return false
        }

        if !currentUser.email.isValidEmail() {
            UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Enter a valid email", completion: nil)
            return false
        }

        if currentUser.password.length() == 0 {
            UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Enter password", completion: nil)
            return false
        }

        return true
    }
}

//MARK:- LoginSignupTableViewDelegate
extension LoginViewController:LoginSignupTableViewDelegate{
    func buttonPressed(type: ButtonCellType) {
        UIApplication.dismissKeyboard()
        if checkData() {
            if NetworkClass.isConnected(true) {
                showLoaderOnWindow()
                NetworkClass.sendRequest(URL: Constants.URLs.login, RequestType: .POST, Parameters: currentUser.getLoginDictionary(), Headers: nil, CompletionHandler: {
                    (status, responseObj, error, statusCode) in
                    NSUserDefaults.saveUser(responseObj)
                    self.hideLoader()
                })
            }
        }
    }
}
