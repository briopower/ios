
//
//  ShowAddJournalViewController.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/10/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit



protocol ShowAddJournalViewControllerDelegate {
    func savedOrUpdatedNewJournal()
}

class ShowAddJournalViewController: CommonViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var journalTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    
    // MARK: - Variables
    var delegate: ShowAddJournalViewControllerDelegate?
    var isNewJournal = false
    var isEditMode = false     // this mode is true/on when we edit a added journal
    var selectedJournal = Journal.init()
    var trackID: String = ""
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        if !isNewJournal{
            // showing existing journal
            journalTextView.text = selectedJournal.description
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
                // TODO below function should be called in completion block
                guard let journalID = self.selectedJournal.id else{
                    UIView.showToast("Something went wrong", theme: Theme.error)
                    return
                }
                self.showLoader()
                let parameter = [
                    "toBeDeletedIds": journalID
                ]
                NetworkClass.sendRequest(URL: Constants.URLs.deleteJournals, RequestType: .post, ResponseType: ExpectedResponseType.none, Parameters: parameter as AnyObject, Headers: nil) { (status: Bool, responseObj, error :NSError?, statusCode: Int?) in
                    self.delegate?.savedOrUpdatedNewJournal()
                    self.hideLoader()
                    if let code = statusCode{
                        if code == 200{
                            print("Updated with status code 200")
                            self.delegate?.savedOrUpdatedNewJournal()
                        }else{
                            // error in request with status code
                            UIView.showToast("Something went wrong", theme: Theme.error)
                            debugPrint("Error in fetching Journals with status code \(String(describing: statusCode))  \(error?.localizedDescription ?? "")")
                        }
                    }else if let err = error{
                        // error  in request
                        UIView.showToast("Something went wrong", theme: Theme.error)
                        debugPrint(err.localizedDescription)
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                    self.getNavigationController()?.popViewController(animated: true)
                }
                
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @objc func editBarButtonTapped(){
        self.isEditMode = true
        self.journalTextView.isEditable = true
        self.journalTextView.becomeFirstResponder()
        let saveBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "tick"), style: .plain, target: self, action: #selector(saveBarButtonTapped))
        getNavigationItem()?.setRightBarButtonItems([saveBarButton], animated: true)
    }
    @objc func saveBarButtonTapped(){
        
        // code to savse or update as needed
        
        if journalTextView.text.isEmpty{
            // TODO alert for empty journal
            UIAlertController.showAlertOfStyle(Message: "Please write something before saving", completion: nil)
        }else{
            if !NetworkClass.isConnected(true){
                // no internet connection
                return
            }
            if journalTextView.isFirstResponder{
                journalTextView.resignFirstResponder()
            }
            showLoader()
            if isNewJournal{
                // TODO save new journal here
                saveNewJournalOnServer()
            }else{
                // TODO updateExisting journal here
                updateExistingJournalOnServer()
            }
            self.isEditMode = false
        }
        
        
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
    
    func saveNewJournalOnServer(){
        
        if trackID.isEmpty {
            // no track ID present
            return
        }
        let parameter = ["description": journalTextView.text,
                         "trackId": trackID,
                         "userId": UserDefaults.getUserId()   ] as [String : Any]
        NetworkClass.sendRequest(URL: Constants.URLs.saveJournal, RequestType: .post, ResponseType: ExpectedResponseType.string, Parameters: parameter as AnyObject, Headers: nil) { (status: Bool, responseObj, error :NSError?, statusCode: Int?) in
            
            self.hideLoader()
            if let code = statusCode{
                if code == 200{
                    print("Journal Saved with status code 200")
                    self.delegate?.savedOrUpdatedNewJournal()
                }else{
                    // error in request
                    debugPrint("Error in fetching Journals with status code \(String(describing: statusCode))  \(error?.localizedDescription ?? "")")
                }
            }else if let err = error{
                // error  in request
                debugPrint(err.localizedDescription)
            }
            self.getNavigationController()?.popViewController(animated: true)
            
        }
    }
    func updateExistingJournalOnServer(){
        
        guard let trackId = selectedJournal.trackId else{
            // no track ID present
            return
        }
        guard  let journalId = selectedJournal.id else {
            // no journal ID present
            return
        }
        guard let descriptionText = journalTextView.text else{
            // nil found this is not that much required as we have already checked this case before calling this function
            return
        }
        
        let parameter = [
                         "description": descriptionText,
                         "id": journalId,
                         "trackId": trackId,
                         "userId": UserDefaults.getUserId()] as [String : Any]
        NetworkClass.sendRequest(URL: Constants.URLs.saveJournal, RequestType: .post, ResponseType: ExpectedResponseType.string, Parameters: parameter as AnyObject, Headers: nil) { (status: Bool, responseObj, error :NSError?, statusCode: Int?) in

            self.hideLoader()
            if let code = statusCode{
                if code == 200{
                    print("Updated with status code 200")
                    self.delegate?.savedOrUpdatedNewJournal()
                }else{
                    // error in request
                    debugPrint("Error in fetching Journals with status code \(String(describing: statusCode))  \(error?.localizedDescription ?? "")")
                }
            }else if let err = error{
                // error  in request
                debugPrint(err.localizedDescription)
            }
            
            self.getNavigationController()?.popViewController(animated: true)
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
        guard let str = updatedText else{ return true } //  nil in string
        str.isEmpty ? (placeHolderLabel.isHidden = false) : (placeHolderLabel.isHidden = true)
        return true
    }
}
