//
//  MessagingViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
let initialHeight:CGFloat = 48.0
let lineHeight:CGFloat = 19.09375

class MessagingViewController: KeyboardAvoidingViewController {

    //MARK:- Outlets
    @IBOutlet weak var msgTblView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!

    //MARK:- Variables
    var shouldScrollToBottom = true

    //MARK:- Life Cycle
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
        if shouldScrollToBottom {
            moveToBottom()
            shouldScrollToBottom = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Button action
extension MessagingViewController{
    override func detailsButtonAction(sender: UIButton?) {
        super.detailsButtonAction(sender)
        UIAlertController.showAlertOfStyle(.ActionSheet, Title: nil, Message: nil, OtherButtonTitles: ["VIEW PROFILE", "CLEAR CHAT"], CancelButtonTitle: "CANCEL") { (tappedAtIndex) in
            debugPrint("CLicked at index\(tappedAtIndex)")
        }
    }
}
//MARK:- Additional methods
extension MessagingViewController{
    func setUpView()
    {
        msgTblView.registerNib(UINib(nibName: String(SentMessageCell), bundle: nil), forCellReuseIdentifier: String(SentMessageCell))
        msgTblView.registerNib(UINib(nibName: String(RecievedMessageCell), bundle: nil), forCellReuseIdentifier: String(RecievedMessageCell))
        msgTblView.estimatedRowHeight = 60
        msgTblView.rowHeight = UITableViewAutomaticDimension
        msgTblView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }

    override func moveToBottom() {
        if (msgTblView.contentSize.height > msgTblView.frame.size.height){
            let point = CGPoint(x: 0, y: msgTblView.contentSize.height - msgTblView.frame.size.height)
            msgTblView.contentOffset = point
        }
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
                let temp = initialHeight - lineHeight + (numberOfLines * lineHeight)
                if temp > initialHeight + 8 {
                    heightConstraint.constant = temp
                }else{
                    heightConstraint.constant = initialHeight
                }
            }
        }
        self.view.layoutIfNeeded()
        moveToBottom()
    }
}

