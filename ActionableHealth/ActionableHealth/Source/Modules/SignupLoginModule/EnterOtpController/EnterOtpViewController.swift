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
        super.viewDidLoad()
        self.setUpView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarWithTitle("ENTER OTP", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional functions
extension EnterOtpViewController{
    func setUpView(){
        showLoginModule = false
        containerOtpView.layer.borderWidth = 0.5
        containerOtpView.layer.borderColor = UIColor.getAppSeperatorColor().CGColor
    }
}

//MARK:- Button actions
extension EnterOtpViewController{
    @IBAction func verifyButton(sender: AnyObject) {
        if NetworkClass.isConnected(true) {
            showLoader()
            if let localDict = phoneDetail{
                if let phone = localDict["phone"], let otp = otpTextField.text{
                    let verifyUrl = "\(Constants.URLs.verifyOtp)\(phone)/\(otp)"
                    NetworkClass.sendRequest(URL: verifyUrl, RequestType: .GET, Parameters: nil , Headers: nil, CompletionHandler: {
                        (status, responseObj, error, statusCode) in
                        if let dict = responseObj as? NSDictionary{
                            if dict["isAuthenticated"] as? Bool == true {
                                NSUserDefaults.saveUser(dict)
                               if let vc = UIStoryboard(name: Constants.Storyboard.SettingsStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.SettingsStoryboard.editProfileView) as? EditProfileViewController {
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }

                            }
                            else{
                                print("Wrong Otp")
                            }
                        }
                        self.hideLoader()
                    })
                }
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
                        print("OTP sent")
                    }
                    else{
                        print("some error occured")
                    }
                }
                self.hideLoader()
            })
        }
    }
}
