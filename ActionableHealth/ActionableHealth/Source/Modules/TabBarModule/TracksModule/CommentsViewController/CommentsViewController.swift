//
//  CommentsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum CommentsSourceType:Int {
    case Track, Phase, Task, Count
}

class CommentsViewController: KeyboardAvoidingViewController {

    //MARK:- Outlets
    @IBOutlet weak var commentsTblView: CommonReverseTableView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    //MARK:- Variables
    var shouldScrollToBottom = true
    var sourceType = CommentsSourceType.Track
    var commentSourceObj:AnyObject?

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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

        debugPrint(commentSourceObj)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Comments", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//MARK:- Actions 
extension CommentsViewController{
    @IBAction func sendAction(sender: UIButton) {
        if NetworkClass.isConnected(false) {
            sendMessage(txtView.text.getValidObject() ?? "", key: "")
        }
    }
}
//MARK:- Additonal methods
extension CommentsViewController{
    func setupView() {
        commentsTblView.tableViewType = ReverseTableViewType.Comments
        commentsTblView.estimatedRowHeight = 100
        commentsTblView.dataArray = ["", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", ""]
        commentsTblView.reverseTableViewDelegate = self
        getComments()
    }

    override func moveToBottom() {
        if (commentsTblView.contentSize.height > commentsTblView.frame.size.height){
            let point = CGPoint(x: 0, y: commentsTblView.contentSize.height - commentsTblView.frame.size.height)
            commentsTblView.contentOffset = point
        }
    }
}

//MARK:- ReverseTableViewDelegate
extension CommentsViewController:ReverseTableViewDelegate{
    func topElements(view: UIView) {
        debugPrint("Get Top Elemets")
    }

    func clickedAtIndexPath(indexPath: NSIndexPath, obj: AnyObject) {
        
    }
}

//MARK:- UITextViewDelegate
extension CommentsViewController:UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        placeHolderLabel.hidden = !(textView.text.length() == 0)
        if textView.text.getValidObject() != nil  {
            sendButton.enabled = true

        }else{
            sendButton.enabled = false
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
//MARK:- Network Methods
extension CommentsViewController{
    func getComments() {
        
    }

    func sendMessage(message:String, key:String) {

    }
}
