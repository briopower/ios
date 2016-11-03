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
extension SignUpViewController{
    func setupView() {
        tblView.setupTableView(LoginSignupTableViewSourceType.Signup, user: currentUser)
        tblView.loginSignupTblViewDelegate = self
        CommonMethods.addShadowToView(container)
        CommonMethods.setCornerRadius(signupButton)
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

        if currentUser.confirmPassword.length() == 0 {
            UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Re-enter password", completion: nil)
            return false
        }

        if currentUser.confirmPassword != currentUser.password {
            UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Password mismatch", completion: nil)
            return false
        }

        if currentUser.password.length() < 6 {
            UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Password must contain atleast 6 characters", completion: nil)
            return false
        }

        return true
    }
}

//MARK:- LoginSignupTableViewDelegate
extension SignUpViewController:LoginSignupTableViewDelegate{
    func buttonPressed(type: ButtonCellType) {
        UIApplication.dismissKeyboard()
        if checkData() {
            if NetworkClass.isConnected(true) {
                showLoaderOnWindow()
                NetworkClass.sendRequest(URL: Constants.URLs.signup, RequestType: .POST, Parameters: currentUser.getSignupDictionary(), Headers: nil, CompletionHandler: {
                    (status, responseObj, error, statusCode) in
                    
                    if let responseDictionary = responseObj as? Dictionary<String, AnyObject>{
                        
                        if let emailExist = (responseDictionary["exists"] as? Bool){
                            if !emailExist{
                                
                                
                                UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Title: "Signup Authentication", Message: "Mail sent to your emailid", OtherButtonTitles: nil, CancelButtonTitle: "ok", completion: {UIAlertAction in
                                    self.navigationController?.popViewControllerAnimated(true)})
                                
                            }
                                
                            else{
                                UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Title: "Signup Authentication", Message: "email id Already Registered With Us", OtherButtonTitles: nil, CancelButtonTitle: "ok", completion: nil)
                                
                            }
                            
                        }
                    }
                    self.hideLoader()
                })
            }
        }
        
    }
}

//MARK:- Button Actions
extension SignUpViewController{
    @IBAction func loginAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
