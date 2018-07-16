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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - Keyboard Methods
extension KeyboardAvoidingViewController{

    func keyboardWillAppear(_ notification:Notification) {
        let keyboardSize:CGSize = ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size)
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        self.view.layoutIfNeeded()
        constraintBottomSpace?.constant = keyboardSize.height
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue:curve.intValue)!)
        UIView.setAnimationDuration(duration.doubleValue)
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        self.perform(#selector(self.moveToBottom), with: nil, afterDelay: duration.doubleValue)

    }

    func keyboardWillDisappear(_ notification:Notification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue:curve.intValue)!)
        UIView.setAnimationDuration(duration.doubleValue)
        constraintBottomSpace?.constant = 0
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        self.perform(#selector(self.moveToBottom), with: nil, afterDelay: duration.doubleValue)
    }

    func moveToBottom() {
        
    }

}
