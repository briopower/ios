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

extension EnterOtpViewController{
    func setUpView(){
        showLoginModule = false
        containerOtpView.layer.borderWidth = 0.5
        containerOtpView.layer.borderColor = UIColor.getAppSeperatorColor().CGColor
    }
}
extension EnterOtpViewController{
    @IBAction func verifyButton(sender: AnyObject) {
    }
  
    
    @IBAction func resendCodeButton(sender: AnyObject) {
    }
    
    
}
