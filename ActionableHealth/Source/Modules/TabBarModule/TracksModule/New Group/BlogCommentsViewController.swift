//
//  BlogCommentsViewController.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/8/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit
import GrowingTextView
import DAKeyboardControl

class BlogCommentsViewController: CommonViewController {

    // MARK: - outlets
    
    @IBOutlet weak var commentTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var commentTextView: GrowingTextView!
    
    // MARK: - variables
    
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarWithTitle("Comments", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        setUpCommentsTableView()
        commentTextView.layer.cornerRadius = 10
        commentTextView.delegate = self
        commentTextView.textContainerInset = UIEdgeInsets.init(top: 12, left: 10, bottom: 10, right: 10)
        self.keyboardSetUp()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.removeKeyboardControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Userdefined functions
    func setUpCommentsTableView(){
        commentsTableView.register(CommentsTableViewCell.cellNib, forCellReuseIdentifier: CommentsTableViewCell.cellIdentifier)
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.estimatedRowHeight = 100
        commentsTableView.rowHeight = UITableViewAutomaticDimension
    }
    func keyboardSetUp(){
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification) in
            let keyboardRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardHeight = keyboardRect.size.height
            self.commentTextViewBottomConstraint.constant = keyboardHeight + CGFloat(10)
            UIView.beginAnimations(Notification.Name.UIKeyboardWillShow.rawValue, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!)
            UIView.setAnimationDuration(TimeInterval((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue))
            self.view.layoutIfNeeded()
            UIView.commitAnimations()
        }
        
        // Keyboard hide
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification) in
            self.commentTextViewBottomConstraint.constant = CGFloat(10)
             UIView.beginAnimations(Notification.Name.UIKeyboardWillHide.rawValue, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!)
            UIView.setAnimationDuration(TimeInterval((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue))
            self.view.layoutIfNeeded()
            UIView.commitAnimations()
        }
    }
    
    // MARK: - Button actions
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
    }
    
}
// MARK: - UITableViewDataSource
extension BlogCommentsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.cellIdentifier, for: indexPath) as! CommentsTableViewCell
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BlogCommentsViewController: UITableViewDelegate{
    
}
extension BlogCommentsViewController: GrowingTextViewDelegate{
    
}
