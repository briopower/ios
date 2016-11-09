//
//  VerifyPhoneNumberViewController.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 05/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class VerifyPhoneNumberViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var headingLabel: UILabel_FontSizeLabel!
    

  
    
    @IBOutlet weak var clickHereTextView: UITextView!
   
    @IBOutlet weak var verifyPhoneNumber: UIButton_FontSizeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        verifyPhoneNumber.contentHorizontalAlignment = .Left
        
        
        let attributedString = clickHereTextView.attributedText.mutableCopy()
        
         clickHereTextView.font = UIFont.getAppRegularFontWithSize(15.5)?.getDynamicSizeFont()
        let myRange = NSRange(location: 129, length: 10)
        let myCustomAttribute = [ "MyCustomAttributeName": "some value"]
        attributedString.addAttributes(myCustomAttribute, range: myRange)
        
        clickHereTextView.attributedText = attributedString as! NSAttributedString
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resendOtp(_:)))
        tap.delegate = self
        clickHereTextView.addGestureRecognizer(tap)
        
        
        
        
    }

    func resendOtp(sender: UITapGestureRecognizer) {
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.locationInView(myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndexForPoint(location, inTextContainer: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            
            // check if the tap location has a certain attribute
            let attributeName = "MyCustomAttributeName"
            if myTextView.attributedText.attribute(attributeName, atIndex: characterIndex, effectiveRange: nil) != nil{
                // call api here
            }
            
            
        }
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
