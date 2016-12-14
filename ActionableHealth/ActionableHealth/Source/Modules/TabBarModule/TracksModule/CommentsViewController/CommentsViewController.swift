//
//  CommentsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
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

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
            if let text = txtView.text.getValidObject(), let key = commentSourceKey {
                sendMessage(text, key: key)
            }
        }
    }
}
//MARK:- Additonal methods
extension CommentsViewController{
    func setupView() {
        commentsTblView.tableViewType = TableViewType.Comments
        commentsTblView.commonTableViewDelegate = self
        getComments("")
    }

    func reset() {
        getComments("")
    }

    func processResponse(responseObj:AnyObject?, cursorVal:String) {
        txtView.text = ""
        textViewDidChange(txtView)
        if let dict = responseObj {
            delegate?.updatedCommentCount(CommentsModel.getCommentsCount(dict))

            if cursorVal == "" {
                commentsTblView.dataArray.removeAllObjects()
                commentsTblView.reloadData()
            }

            let commentsArr = CommentsModel.getCommentsResponseArray(dict)

            let arr = NSMutableArray()

            for obj in commentsArr {
                let comment = CommentsModel.getCommentObj(obj)
                arr.addObject(comment)
            }

            commentsTblView.insertElements(arr)

            if let cursorVal = TemplatesModel.getCursor(dict){
                cursor = cursorVal
                commentsTblView.hasMoreActivity = true
            }else{
                cursor = ""
                commentsTblView.hasMoreActivity = false
            }

        }
        commentsTblView.removeBottomLoader()
    }

    func processError(error:NSError?) {

    }
}

//MARK:- ReverseTableViewDelegate
extension CommentsViewController:CommonTableViewDelegate{
    func topElements(view:UIView){
    }
    func bottomElements(view:UIView){
        getComments(cursor)
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
//MARK:- Network Methods
extension CommentsViewController{
    func getComments(cursorVal:String) {
        if NetworkClass.isConnected(true), let key = commentSourceKey{
            if commentsTblView.dataArray.count == 0 {
                showLoader()
            }
            NetworkClass.sendRequest(URL:Constants.URLs.getComments, RequestType: .POST, Parameters: CommentsModel.getPayloadDict(key, cursor: cursorVal, query: ""), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if status{
                    self.processResponse(responseObj, cursorVal: cursorVal)
                }else{
                    self.processError(error)
                }
                self.hideLoader()
            })
        }
    }

    func sendMessage(message:String, key:String) {
        if NetworkClass.isConnected(true) {
            showLoader()
            UIApplication.disableInteraction()
            NetworkClass.sendRequest(URL: Constants.URLs.comment, RequestType: .POST, Parameters: CommentsModel.getPayloadDictForCommenting(key, commnt: message), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if statusCode == 200{
                    self.reset()
                }else{
                    self.hideLoader()
                }
            })
        }
    }
}
