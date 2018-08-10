//
//  ShowAddJournalViewController.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/10/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit

class ShowAddJournalViewController: CommonViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var journalTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    
    // MARK: - Variables
    
    var isNewJournal = false
    var isEditMode = false     // this mode is when we edit a added journal
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isNewJournal{
            // showing existing journal
            placeHolderLabel.isHidden = true
            journalTextView.isEditable = false
            setNavigationBarWithTitle("", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
            
            let deleteBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "delete"), style: .plain, target: self, action: #selector(deleteBarButtonTapped))
            let editBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Edit"), style: .plain, target: self, action: #selector(editBarButtonTapped))
            getNavigationItem()?.rightBarButtonItems = [editBarButton,deleteBarButton]
        }else{
            // adding new journal
            journalTextView.text = ""
            journalTextView.isEditable = true
            placeHolderLabel.isHidden = false
            setNavigationBarWithTitle("New Note", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
            
            let saveBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "tick"), style: .plain, target: self, action: #selector(saveBarButtonTapped))
            
            getNavigationItem()?.rightBarButtonItem = saveBarButton
        }
        journalTextView.delegate = self
        self.keyboardSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - BarButtonsActions
    @objc func deleteBarButtonTapped(){
        // delete this
        let alertTitleArray = ["OK"]
        UIAlertController.showAlertOfStyle(.alert, Title: "Delete Journal", Message: "Are you sure you want to delete this Journal", OtherButtonTitles: alertTitleArray, CancelButtonTitle: "Cancel") { (index: Int?) in
            guard let indexOfAlert = index else {return}
            switch(indexOfAlert){
            case 0:
                // here write code of OK button tapped
                //TODO code to call delete API
                // TODO also call get For Journal API here
                // TODO below function should be called in completion block
                
                self.dismiss(animated: true, completion: nil)
                self.getNavigationController()?.popViewController(animated: true)
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @objc func editBarButtonTapped(){
        journalTextView.isEditable = true
        journalTextView.becomeFirstResponder()
        let saveBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "tick"), style: .plain, target: self, action: #selector(saveBarButtonTapped))
        getNavigationItem()?.setRightBarButtonItems([saveBarButton], animated: true)
    }
    @objc func saveBarButtonTapped(){
        // code to save or update as needed
        if journalTextView.isFirstResponder{
            journalTextView.resignFirstResponder()
        }
        if isNewJournal{
            // TODO save new journal here
        }else{
            // TODO updateExisting journal here
        }
        getNavigationController()?.popViewController(animated: true)
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - User defined functions
extension ShowAddJournalViewController{
    func keyboardSetUp(){
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification) in
            let keyboardRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardHeight = keyboardRect.size.height
            UIView.beginAnimations(Notification.Name.UIKeyboardWillShow.rawValue, context: nil)
            self.journalTextViewBottomConstraint.constant = keyboardHeight + CGFloat(10)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!)
            UIView.setAnimationDuration(TimeInterval((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue))
            UIView.commitAnimations()
            self.view.layoutIfNeeded()
        }
        
        // Keyboard hide
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification) in
            UIView.beginAnimations(Notification.Name.UIKeyboardWillHide.rawValue, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!)
            UIView.setAnimationDuration(TimeInterval((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue))
            self.journalTextViewBottomConstraint.constant = CGFloat(10)
            UIView.commitAnimations()
            self.view.layoutIfNeeded()
        }
    }
}
extension ShowAddJournalViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        //
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //
        let nsString = textView.text as NSString?
        let updatedText = nsString?.replacingCharacters(in: range, with: text)

        (updatedText?.isEmpty ?? true) ? (placeHolderLabel.isHidden = false) : (placeHolderLabel.isHidden = true)
        return true
    }
}
