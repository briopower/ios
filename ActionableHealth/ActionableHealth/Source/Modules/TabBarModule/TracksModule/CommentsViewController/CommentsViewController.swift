//
//  CommentsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

let initialHeight:CGFloat = 48.0
let lineHeight:CGFloat = 19.09375

protocol CommentsViewControllerDelegate:NSObjectProtocol {
    func updatedCommentCount(count:Int)
}
class CommentsViewController: KeyboardAvoidingViewController {

    //MARK:- Outlets
    @IBOutlet weak var commentsTblView: CommonTableView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    //MARK:- Variables
    weak var delegate:CommentsViewControllerDelegate?

    var commentSourceKey:String?
    var cursor = ""
    var titleString = "Group Chat"
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle(titleString, LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        CommentsManager.sharedInstance.closeCommentSession()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

//MARK:- Actions
extension CommentsViewController{
    @IBAction func sendAction(sender: UIButton) {
        if NetworkClass.isConnected(false) {
            if let text = txtView.text.getValidObject(), let _ = commentSourceKey {
                CommentsManager.sharedInstance.send(text)
                txtView.text = ""
                textViewDidChange(txtView)
            }
        }
    }
}
//MARK:- Additonal methods
extension CommentsViewController{
    func setupView() {
        txtView.font = UIFont.getAppRegularFontWithSize(17)?.getDynamicSizeFont()
        commentsTblView.tableViewType = TableViewType.Comments
        commentsTblView.commonTableViewDelegate = self
        if let key = commentSourceKey {
            CommentsManager.sharedInstance.openCommentSession(key)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.receivedComment(_:)), name: CommentsManager.sharedInstance.commentReceived, object: nil)
    }

    func receivedComment(notification:NSNotification) {
        if let obj = notification.object as? [String: AnyObject] {
            let commObj = CommentsModel.getCommentObj(obj)
            commentsTblView.insertElements(NSMutableArray(array: [commObj]), insertAt: InsertAt.Top, section: 0, startIndex: 0)
            delegate?.updatedCommentCount(commentsTblView.dataArray.count)
        }
    }
}

//MARK:- CommonTableViewDelegate
extension CommentsViewController:CommonTableViewDelegate{
    func topElements(view:UIView){
    }
    func bottomElements(view:UIView){
    }
    func clickedAtIndexPath(indexPath:NSIndexPath,obj:AnyObject){
        UIApplication.dismissKeyboard()
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
            let temp = initialHeight - lineHeight + (min(4, numberOfLines) * lineHeight)
            if temp > initialHeight + 8 {
                heightConstraint.constant = temp
            }else{
                heightConstraint.constant = initialHeight
            }
        }
        self.view.layoutIfNeeded()
    }
}
