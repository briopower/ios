//
//  MessagingViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 17/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class MessagingViewController: KeyboardAvoidingViewController {

    //MARK:- Outlets
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!

    //MARK:- Variables
    let initialHeight:CGFloat = 32.0
    let lineHeight:CGFloat = 16.70703125
    var shouldScrollToBottom = true

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("New Chat", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.Details)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldScrollToBottom {
            moveToBottom()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        shouldScrollToBottom = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additional methods
extension MessagingViewController{
    func setUpView()
    {
        chatTableView.registerNib(UINib(nibName: String(SentMessageCell), bundle: nil), forCellReuseIdentifier: String(SentMessageCell))
        chatTableView.registerNib(UINib(nibName: String(RecievedMessageCell), bundle: nil), forCellReuseIdentifier: String(RecievedMessageCell))
        chatTableView.estimatedRowHeight = 60
        chatTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func moveToBottom() {
        if (chatTableView.contentSize.height > chatTableView.frame.size.height){
            let point = CGPoint(x: 0, y: chatTableView.contentSize.height - chatTableView.frame.size.height)
            chatTableView.contentOffset = point
        }
    }
}


//MARK:- Button Actions
extension MessagingViewController{
    @IBAction func tableTapped(sender: UITapGestureRecognizer) {
        UIApplication.dismissKeyboard()
    }

    @IBAction func sendButtonAction(sender: UIButton) {
    }

    override func detailsButtonAction(sender: UIButton?) {
        super.detailsButtonAction(sender)
        UIAlertController.showAlertOfStyle(.ActionSheet, Title: nil, Message: nil, OtherButtonTitles: ["VIEW PROFILE", "CLEAR CHAT"], CancelButtonTitle: "CANCEL") { (tappedAtIndex) in
            print("Clicked at index \(tappedAtIndex)")
        }
    }
}
// MARK: - UITextViewDelegate
extension MessagingViewController :UITextViewDelegate{
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text.getValidObject() != nil {
            sendButton.enabled = true
            placeholderLabel.hidden = true
        }else{
            sendButton.enabled = false
            placeholderLabel.hidden = false
        }
        return true
    }
    func textViewDidChange(textView: UITextView) {
        if textView.text.getValidObject() != nil {
            sendButton.enabled = true
            placeholderLabel.hidden = true
        }else{
            sendButton.enabled = false
            placeholderLabel.hidden = false
        }


        let height = textView.text.getHeight(textView.font, maxWidth: Double(textView.frame.size.width))
        if height == 0 {
            heightConstraint.constant = initialHeight
        }else{
            let numberOfLines = height/lineHeight
            if numberOfLines <= 4 {
                heightConstraint.constant = initialHeight - lineHeight + (numberOfLines * lineHeight)
            }
        }
        self.view.layoutIfNeeded()
        moveToBottom()
    }
}

//MARK:- UITableViewDatasource
extension MessagingViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            if let cell = tableView.dequeueReusableCellWithIdentifier(String(RecievedMessageCell)) as? RecievedMessageCell {
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCellWithIdentifier(String(SentMessageCell)) as? SentMessageCell {
                return cell
            }
        }
        return UITableViewCell()
    }
}