//
//  KeyboardAvoidingViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//


import UIKit
import DAKeyboardControl

class KeyboardAvoidingViewController: CommonViewController {
    //Outlets
    @IBOutlet weak var constraintBottomSpace: NSLayoutConstraint?

    //LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - Keyboard Methods
extension KeyboardAvoidingViewController{

    func keyboardWillAppear(notification:NSNotification) {
        let keyboardSize:CGSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        self.view.layoutIfNeeded()
        constraintBottomSpace?.constant = keyboardSize.height
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue:curve.integerValue)!)
        UIView.setAnimationDuration(duration.doubleValue)
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        self.performSelector(#selector(self.moveToBottom), withObject: nil, afterDelay: duration.doubleValue)

    }

    func keyboardWillDisappear(notification:NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue:curve.integerValue)!)
        UIView.setAnimationDuration(duration.doubleValue)
        constraintBottomSpace?.constant = 0
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        self.performSelector(#selector(self.moveToBottom), withObject: nil, afterDelay: duration.doubleValue)
    }

    func moveToBottom() {
        
    }

}