//
//  AddBlogViewController.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/3/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit

class AddBlogViewController: CommonViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBOutlet weak var editor: RichEditorView!
    
    // MARK: - variables
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleTextView.delegate = self
        editor.placeholder = "Story"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("New Blog", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        
        let saveBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "tick").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(saveBarButtonTapped))
        getNavigationItem()?.rightBarButtonItem = saveBarButton
    }
    
    
    // MARK: - BarButtonActions
    
    @objc func saveBarButtonTapped(){
        // TODO call post api to save the blog
        print("saved")
        getNavigationController()?.popViewController(animated: true)
    }
    func setUpEditorView(){
        editor.placeholder = "Story"
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
// MARK: - UITextViewDelegates
extension AddBlogViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if let text = textView.text,
//            let textRange = Range(range, in: text) {
//            let updatedText = text.replacingCharacters(in: textRange,
//                                                       with: text)
//            if !updatedText.isEmpty{
//                // text of title to work on
//                placeHolderLabel.isHidden = true
//            }else{
//                placeHolderLabel.isHidden = false
//            }
//        }
        
        let nsString = textView.text as NSString?
        let updatedText = nsString?.replacingCharacters(in: range, with: text)
        if let text = updatedText, !text.isEmpty{
            // text of title to work on
            placeHolderLabel.isHidden = true
        }else{
            placeHolderLabel.isHidden = false
        }

        return true
    }
}




