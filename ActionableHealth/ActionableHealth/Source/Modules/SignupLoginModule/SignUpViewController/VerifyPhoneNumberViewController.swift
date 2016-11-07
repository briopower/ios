//
//  VerifyPhoneNumberViewController.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 05/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class VerifyPhoneNumberViewController: UIViewController {
    @IBOutlet weak var headingLabel: UILabel_FontSizeLabel!
    

  
    
    @IBOutlet weak var clickHereTextView: UITextView!
   
    @IBOutlet weak var verifyPhoneNumber: UIButton_FontSizeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        verifyPhoneNumber.contentHorizontalAlignment = .Left
        let attributedString = clickHereTextView.attributedText.mutableCopy()
        attributedString.addAttribute(NSLinkAttributeName, value: "", range: NSRange(location: 128, length: 10))
        
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
}

extension VerifyPhoneNumberViewController{
    
    @IBAction func crossButton(sender: AnyObject) {
    }
    
    @IBAction func verifyPhoneNumber(sender: AnyObject) {
        self.performSegueWithIdentifier("enterOtp", sender: self)
    }
}
