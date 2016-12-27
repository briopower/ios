//
//  EnterOtpViewController.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 05/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class EnterOtpViewController: CommonViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var otpTextField: UITextField_FontSizeTextField!
    
    @IBOutlet weak var containerOtpView: UIView!
    
    //MARK:- Variables
    var phoneDetail:NSDictionary?
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        showLoginModule = false
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarWithTitle("Enter OTP", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional functions
extension EnterOtpViewController{
    func setUpView(){
        containerOtpView.layer.borderWidth = 0.5
        containerOtpView.layer.borderColor = UIColor.getAppSeperatorColor().CGColor
    }
    
    func processResponse(responseObj:AnyObject?) {
        if let dict = responseObj as? NSDictionary{
            if dict["isAuthenticated"] as? Bool == true {
                NSUserDefaults.saveUser(dict)
                AppDelegate.getAppDelegateObject()?.setupOnAppLauch()
                ContactSyncManager.sharedInstance.syncCoreDataContacts()
                if let vc = UIStoryboard(name: Constants.Storyboard.SettingsStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.SettingsStoryboard.editProfileView) as? EditProfileViewController {
                    vc.type = .UpdateProfile
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Invalid OTP !", completion: nil)
            }
        }
    }
    
    func processError(error:NSError?) {
        
    }
    
    func checkFields() -> Bool {
        if otpTextField.text?.getValidObject() == nil {
            UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Enter OTP", completion: nil)
            return false
        }
        return true
    }
}

//MARK:- Button actions
extension EnterOtpViewController{
    @IBAction func verifyButton(sender: AnyObject) {
        if NetworkClass.isConnected(true) {
            showLoader()
            if checkFields() {
                UIApplication.dismissKeyboard()
                NetworkClass.sendRequest(URL: "\(Constants.URLs.verifyOtp)\(phoneDetail!["phone"]!)/\(otpTextField.text ?? "")", RequestType: .GET, Parameters: nil , Headers: nil, CompletionHandler: {
                    (status, responseObj, error, statusCode) in
                    
                    if status{
                        self.processResponse(responseObj)
                    }else{
                        self.processError(error)
                    }
                    
                    self.hideLoader()
                })
            }
        }
    }
    
    @IBAction func resendCodeButton(sender: AnyObject) {
        if NetworkClass.isConnected(true) {
            showLoader()
            NetworkClass.sendRequest(URL: Constants.URLs.requestOtp, RequestType: .POST, Parameters: phoneDetail , Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if let dict = responseObj as? NSDictionary{
                    if dict["exists"] as? Bool == true{
                        debugPrint("OTP sent")
                    }
                    else{
                        debugPrint("some error occured")
                    }
                }
                self.hideLoader()
            })
        }
    }
}
