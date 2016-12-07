//
//  EnterOtpViewController.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 05/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class EnterOtpViewController: CommonViewController {
    
    @IBOutlet weak var otpTextField: UITextField_FontSizeTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoginModule = false
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
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
    @IBAction func verifyButton(sender: AnyObject) {
    }
  
    
    @IBAction func resendCodeButton(sender: AnyObject) {
    }
    
    
}
