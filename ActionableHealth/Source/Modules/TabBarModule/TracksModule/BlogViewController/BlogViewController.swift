//
//  BlogViewController.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/6/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit

class BlogViewController: CommonViewController {

    // MARK: - Outlets
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var commentButtonBgView: UIView!
    
    
    // MARK: - Variables
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarWithTitle("", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        
        let deleteBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "delete"), style: .plain, target: self, action: #selector(deleteBarButtonTapped))
        let editBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Edit"), style: .plain, target: self, action: #selector(editBarButtonTapped))
        getNavigationItem()?.rightBarButtonItems = [editBarButton,deleteBarButton]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Button Actions
    @IBAction func viewCommentsButtonTapped(_ sender: UIButton) {
        print("Comments")
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.blogCommentListView) as? BlogCommentsViewController{
            // TODO pass necessary thing to next controller
            //viewCont.currentTemplate = currentTemplate
            self.getNavigationController()?.pushViewController(viewCont, animated: true)
        }
        
    }
    // MARK: - BarButtonsActions
    @objc func deleteBarButtonTapped(){
        // delete this
        let alertTitleArray = ["OK"]
        UIAlertController.showAlertOfStyle(.alert, Title: "Delete Blog", Message: "Are you sure you want to delete this Blog", OtherButtonTitles: alertTitleArray, CancelButtonTitle: "Cancel") { (index: Int?) in
            guard let indexOfAlert = index else {return}
            switch(indexOfAlert){
            case 0:
                // here write code of OK button tapped
                //TODO code to call delete API
                // TODO also call get For Blog API here
                // TODO below function should be called in completion block
                
                self.dismiss(animated: true, completion: nil)
                self.getNavigationController()?.popViewController(animated: true)
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @objc func editBarButtonTapped(){
        //self.isEditMode = true
        //self.journalTextView.isEditable = true
        //self.journalTextView.becomeFirstResponder()
        let saveBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "tick"), style: .plain, target: self, action: #selector(saveBarButtonTapped))
        getNavigationItem()?.setRightBarButtonItems([saveBarButton], animated: true)
    }
    @objc func saveBarButtonTapped(){
        
        // code to save or update as needed
//        if journalTextView.isFirstResponder{
//            journalTextView.resignFirstResponder()
//        }
//        if isNewJournal{
//            // TODO save new journal here
//        }else{
//            // TODO updateExisting journal here
//        }
//        self.isEditMode = false
        self.getNavigationController()?.popViewController(animated: true)
    }
    
}
