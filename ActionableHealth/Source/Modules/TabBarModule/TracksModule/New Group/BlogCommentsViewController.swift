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
    
    var blogCommentManager = BlogCommentsManager()
    var blogComments = [BlogComment]()
    let pageSize = 10
    var isRequestSent = false
    var blogId: String?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO - remove this static blog id
//        blogId = "9092833956765760217"
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
        self.getBlogsCommentsFromServer()
    }

    // MARK: - Userdefined functions
    func setUpCommentsTableView(){
        commentsTableView.register(CommentsTableViewCell.cellNib, forCellReuseIdentifier: CommentsTableViewCell.cellIdentifier)
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.estimatedRowHeight = 100
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        commentsTableView.tableFooterView = UIView()
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
    
    func getBlogsCommentsFromServer(showLoader: Bool = true){
        if !NetworkClass.isConnected(true){
            // no internet connection
            if blogComments.isEmpty{
                commentsTableView.setNoDataView(textColor: .getAppThemeColor(), message: Constants.NoDataViewText.blogCommentList)
            }else{
                commentsTableView.removeNoDataView()
            }
            return
        }
        if isRequestSent{
            // already sent a request therefore wait for the previous request to complete
            return
        }
        
        guard let blogID = self.blogId else{
            // TODO - this means there is no blog id please update suitable error
            return
        }
        guard let cursor = blogCommentManager.cursor else {
            // this means there is no more Comment please update suitably
            return
        }
        let parameter = [
            "cursor": cursor,
            "pageSize": String(pageSize),
            "query": "",
            "blogId": blogID
        ]
        if showLoader{
            self.showLoader()
        }
        self.isRequestSent = true
        NetworkClass.sendRequest(URL: Constants.URLs.getBlogComments, RequestType: .post, ResponseType: ExpectedResponseType.string, Parameters: parameter as AnyObject, Headers: nil) { (status: Bool, responseObj, error :NSError?, statusCode: Int?) in
            
            if showLoader{
                self.hideLoader()
            }else{
                self.removeLoaderFromFooter()
            }
            if let code = statusCode{
                if code == 200{
                    let responseDict = CommonMethods.getDictFromJSONString(jsonString: responseObj as? String )
                    self.blogCommentManager = BlogCommentsManager.initWithDict(dict: responseDict)
                    if let newBlogComments = self.blogCommentManager.commentResultSet{
                        self.blogComments.append(contentsOf: newBlogComments)
                        self.commentsTableView.reloadData()
                    }
                    
                    // Adding and removing no Data view
                    if self.blogComments.isEmpty{
                        self.commentsTableView.setNoDataView(textColor: .getAppThemeColor(), message: Constants.NoDataViewText.blogCommentList)
                    }else{
                        self.commentsTableView.removeNoDataView()
                    }
                    
                }else{
                    // error in request
                    debugPrint("Error in fetching BlogComments with status code \(String(describing: statusCode))  \(error?.localizedDescription ?? "")")
                }
            }else if let err = error{
                // error  in request
                debugPrint(err.localizedDescription)
            }
            self.isRequestSent = false
        }
    }
    
    func addNewCommentOnServer(){
        
        guard let blogID = self.blogId else {
            // no blog ID to send on server
            return
        }
        if blogID.isEmpty{
            // no blogid present
            return
        }
        var createdBy = UserDefaults.getUserId()
        if let name = UserModel.getCurrentUser().firstName{
            createdBy = name
            if let lastName = UserModel.getCurrentUser().lastName{
                createdBy.append(" \(lastName)")
            }
        }
        
        let parameter = ["description": commentTextView.text,
                         "blogId": blogID,
                         "createdBy": createdBy   ] as [String : Any]
        NetworkClass.sendRequest(URL: Constants.URLs.saveBlogComment, RequestType: .post, ResponseType: ExpectedResponseType.string, Parameters: parameter as AnyObject, Headers: nil) { (status: Bool, responseObj, error :NSError?, statusCode: Int?) in
            
            self.hideLoader()
            if let code = statusCode{
                if code == 200{
                    self.commentTextView.text.removeAll()
                    print("comment Saved with status code 200")
                    self.blogComments.removeAll()
                    self.blogCommentManager.cursor = ""
                    self.getBlogsCommentsFromServer()
                }else{
                    // error in request
                    debugPrint("Error in saving Comment with status code \(String(describing: statusCode))  \(error?.localizedDescription ?? "")")
                }
            }else if let err = error{
                // error  in request
                debugPrint(err.localizedDescription)
            }
            
        }
    }
    
    func showLoaderInTableFootor(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.tag = 555
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: commentsTableView.bounds.width, height: CGFloat(44))
        
        self.commentsTableView.tableFooterView = spinner
        self.commentsTableView.tableFooterView?.isHidden = false
    }
    
    func removeLoaderFromFooter(){
        self.commentsTableView.tableFooterView = nil
        
    }
    
    // MARK: - Button actions
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if commentTextView.text.isEmpty{
            // TODO alert for empty journal
            UIAlertController.showAlertOfStyle(Message: "Please write something before saving", completion: nil)
        }else{
            if !NetworkClass.isConnected(true){
                // no internet connection
                return
            }
            if commentTextView.isFirstResponder{
                commentTextView.resignFirstResponder()
            }
            self.addNewCommentOnServer()
            
        }
    }
    
}
// MARK: - UITableViewDataSource
extension BlogCommentsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogComments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.cellIdentifier, for: indexPath) as! CommentsTableViewCell
        cell.blogComment = blogComments[indexPath.row]
        cell.configCell()
        return cell
    }
}


// MARK: - UITableViewDelegate
extension BlogCommentsViewController: UITableViewDelegate{
    
}

// MARK: - UIScrollViewDelegate
extension BlogCommentsViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let _ = self.blogCommentManager.cursor else {
            // no more blog list present on server
            return
        }
        if let visibleIndex = commentsTableView.indexPathsForVisibleRows?.last?.row{
            if (visibleIndex % (pageSize-1)) < 3 && !self.isRequestSent{
                self.showLoaderInTableFootor()
                self.getBlogsCommentsFromServer(showLoader: false)
            }
        }

    }
}

// MARK: - GrowingTextViewDelegate
extension BlogCommentsViewController: GrowingTextViewDelegate{
    
}
