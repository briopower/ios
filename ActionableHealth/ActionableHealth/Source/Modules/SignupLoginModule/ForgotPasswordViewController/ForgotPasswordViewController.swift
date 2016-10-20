//
//  ForgotPasswordViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: CommonViewController {
    //MARK:- Outlets
    @IBOutlet weak var tblView: LoginSignupTableView!


    //MARK:- Variables
    var currentUser = UserModel()

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
//MARK:- Button Actions
extension ForgotPasswordViewController{
    @IBAction func dismissViewControllerAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
//MARK:- Additional Methods
extension ForgotPasswordViewController{
    func setupView() {
        tblView.setupTableView(LoginSignupTableViewSourceType.ForgotPassword, user: currentUser)
        tblView.loginSignupTblViewDelegate = self
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
        return true
    }
}

//MARK:- LoginSignupTableViewDelegate
extension ForgotPasswordViewController:LoginSignupTableViewDelegate{
    func buttonPressed(type: ButtonCellType) {
        UIApplication.dismissKeyboard()
        if checkData() {
            if NetworkClass.isConnected(true) {
                showLoaderOnWindow()
//                NetworkClass.sendRequest(URL: Constants.URLs.login, RequestType: .POST, Parameters: currentUser.getLoginDictionary(), Headers: nil, CompletionHandler: {
//                    (status, responseObj, error, statusCode) in
//                    NSUserDefaults.saveUser(responseObj)
//                    self.hideLoader()
//                })
            }
        }
    }
}
