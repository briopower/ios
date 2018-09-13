//
//  BlogsListViewController.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/3/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit

class BlogsListViewController: CommonViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var deleteButtonBgViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonBGView: UIView!
    @IBOutlet weak var blogsTableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK:- Variables
    var currentTemplate:TemplatesModel?
    var sourceType = TrackDetailsSourceType.templates
    var isDeleteModeOn = false
    var blogManager = BlogsManager()
    var blogs = [Blog]()
    let pageSize = 10
    var isRequestSent = false
    var totalItemsSelectedForDelete: Int = 0
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // as it is shown after delete mode on
        self.hideDeleteButtonView()
        setNavigationBarWithTitle("Blogs", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        
        let actionSheetBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "actionSheet"), style: .plain, target: self, action: #selector(actionSheetBarButtonTapped))
        getNavigationItem()?.rightBarButtonItem = actionSheetBarButton
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getBlogsFromServer()
    }
    
    // MARK: - BarButtonActions
    @objc func actionSheetBarButtonTapped(){
        let actionSheetController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        if !blogs.isEmpty{
            actionSheetController.addAction(UIAlertAction.init(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
                // code here for Delete Action
                self.isDeleteModeOn = !self.isDeleteModeOn
                self.dismiss(animated: true, completion: nil)
                self.blogsTableView.reloadData()
                let cancelBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "cut").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.cancelBarButtonTapped))
                self.getNavigationItem()?.rightBarButtonItem = cancelBarButton
                self.showDeleteButtonView()
                
            }))
        }
        actionSheetController.addAction(UIAlertAction.init(title: "Add New Blog", style: .default, handler: { (action: UIAlertAction) in
            // code here for addding a new Blog
            self.dismiss(animated: true, completion: nil)
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.addNewBlogView) as? AddBlogViewController{
                // TODO pass necessary thing to next controller
                if let trackID = self.currentTemplate?.trackId{
                    viewCont.trackID = trackID
                }
                viewCont.delegate = self
                viewCont.addNewBlogUrl = Constants.URLs.saveBlog
                viewCont.createBlogImageUploadUrl = Constants.URLs.createBlogImageUploadURL
                viewCont.getBlogImageUrl = Constants.URLs.getBlogImageUrl
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            }
            
            
        }))
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheetController.view.tintColor = UIColor.getAppThemeColor()
        present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc func cancelBarButtonTapped(){
        self.hideDeleteButtonView()
        self.isDeleteModeOn = false
        totalItemsSelectedForDelete = 0
        self.setBlogSelectionForDeleteToFalse()
        let actionSheetBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "actionSheet"), style: .plain, target: self, action: #selector(actionSheetBarButtonTapped))
        getNavigationItem()?.rightBarButtonItem = actionSheetBarButton
        blogsTableView.reloadData()
        // TODO also set all selected blog to false
    }
    // MARK: - ButtonActions
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        let alertTitleArray = ["OK"]
        UIAlertController.showAlertOfStyle(.alert, Title: "Delete Blogs", Message: "Are you sure you want to delete the selected blogs?", OtherButtonTitles: alertTitleArray, CancelButtonTitle: "Cancel") { (index: Int?) in
            guard let indexOfAlert = index else {return}
            switch(indexOfAlert){
            case 0:
                self.showLoader()
                
                let parameter = [
                    "toBeDeletedIds": self.getIdsOfBlogsToBeDeleted()
                ]
                NetworkClass.sendRequest(URL: Constants.URLs.deleteBlogs, RequestType: .post, ResponseType: ExpectedResponseType.json, Parameters: parameter as AnyObject, Headers: nil) { (status: Bool, responseObj, error :NSError?, statusCode: Int?) in
                    
                    self.hideLoader()
                    if let error = error{
                        UIView.showToast(error.localizedDescription, theme: Theme.error)
                        self.cancelBarButtonTapped()
                        self.dismiss(animated: true, completion: nil)
                        return
                    }
                    
                    if let code = statusCode, code == 200{
                        //  data from server is success
                        self.blogManager.cursor = ""
                        self.blogs.removeAll()
                        self.getBlogsFromServer()
                    }else {
                        // some error
                        UIView.showToast("Something went wrong", theme: Theme.error)
                    }
                    self.cancelBarButtonTapped()
                    self.dismiss(animated: true, completion: nil)
                }
                
            default:
                self.dismiss(animated: true, completion: nil)
            }
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

// MARK: - extra functions
extension BlogsListViewController{
    
    func setUpTableView(){
        blogsTableView.register(BlogListTableViewCell.cellNib, forCellReuseIdentifier: BlogListTableViewCell.cellIdentifier)
        blogsTableView.rowHeight = UITableViewAutomaticDimension
        blogsTableView.estimatedRowHeight = 90
        blogsTableView.dataSource = self
        blogsTableView.delegate = self
        blogsTableView.tableFooterView = UIView()
    }
    func showDeleteButtonView(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.deleteButtonBgViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    func hideDeleteButtonView(){
        self.deleteButton.isEnabled = false
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.deleteButtonBgViewBottomConstraint.constant = -self.deleteButtonBGView.bounds.height
                self.view.layoutIfNeeded()
            })
        }
    }
    func getIdsOfBlogsToBeDeleted()->[String]{
        var idToBeDeleteArray = [String]()
        for blog in blogs{
            
            if blog.isSelcetedForDelete && blog.id != nil{
                
                idToBeDeleteArray.append(blog.id!)
            }
        }
        return idToBeDeleteArray
    }
    
    func getBlogsFromServer(showLoader: Bool = true){
        if !NetworkClass.isConnected(true){
            // no internet connection
            if blogs.isEmpty{
                blogsTableView.setNoDataView(textColor: .getAppThemeColor(), message: Constants.NoDataViewText.blogList)
            }else{
                blogsTableView.removeNoDataView()
            }
            return
        }
        if isRequestSent{
            // already sent a request therefore wait for the previous request to complete
            return
        }
        
        guard let trackID = self.currentTemplate?.trackId else{
            // TODO - this means there is no track id please update suitable error
            return
        }
        guard let cursor = blogManager.cursor else {
            // this means there is no more blogs please update suitably
            return
        }
        let parameter = [
            "cursor": cursor,
            "pageSize": pageSize,
            "trackId": trackID
            ] as [String : Any]
        if showLoader{
            self.showLoader()
        }
        self.isRequestSent = true
        NetworkClass.sendRequest(URL: Constants.URLs.getBlogs, RequestType: .post, ResponseType: ExpectedResponseType.string, Parameters: parameter as AnyObject, Headers: nil) { (status: Bool, responseObj, error :NSError?, statusCode: Int?) in
            
            if showLoader{
                self.hideLoader()
            }else{
                self.removeLoaderFromFooter()
            }
            if let code = statusCode{
                if code == 200{
                    let responseDict = CommonMethods.getDictFromJSONString(jsonString: responseObj as? String )
                    self.blogManager = BlogsManager.initWithDict(dict: responseDict)
                    if let newBlogs = self.blogManager.blogResultSet{
                        self.blogs.append(contentsOf: newBlogs)
                        self.blogsTableView.reloadData()
                    }
                    
                    // Adding and removing no Data view
                    if self.blogs.isEmpty{
                        self.blogsTableView.setNoDataView(textColor: .getAppThemeColor(), message: Constants.NoDataViewText.blogList)
                    }else{
                        self.blogsTableView.removeNoDataView()
                    }
                    
                }else{
                    // error in request
                    debugPrint("Error in fetching Blogs with status code \(String(describing: statusCode))  \(error?.localizedDescription ?? "")")
                }
            }else if let err = error{
                // error  in request
                debugPrint(err.localizedDescription)
            }
            self.isRequestSent = false
        }
    }
    func showLoaderInTableFootor(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.tag = 555
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: blogsTableView.bounds.width, height: CGFloat(44))
        
        self.blogsTableView.tableFooterView = spinner
        self.blogsTableView.tableFooterView?.isHidden = false
    }
    func removeLoaderFromFooter(){
        self.blogsTableView.tableFooterView = nil
        
    }
    func setBlogSelectionForDeleteToFalse(){
        for blog in blogs{
            if blog.isSelcetedForDelete{
                blog.isSelcetedForDelete = false
            }
        }
    }
    
}

// MARK: - UITableViewDataSource
extension BlogsListViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BlogListTableViewCell.cellIdentifier, for: indexPath) as! BlogListTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.isEdtingMode = self.isDeleteModeOn
        cell.blog = self.blogs[indexPath.row]
        cell.configCell()
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension BlogsListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // worked here when Blog is viewed
        if isDeleteModeOn{
            // cell is selected for the delete since delete mode is active
            if let cell = tableView.cellForRow(at: indexPath) as? BlogListTableViewCell{
                cell.blog?.isSelcetedForDelete = !(cell.blog?.isSelcetedForDelete)!
                self.deleteSelectionButtonTapped((cell.blog?.isSelcetedForDelete)!)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            return
        }
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.blogView) as? BlogViewController{
            // TODO pass necessary thing to next controller such as pass blog details
            viewCont.blog = blogs[indexPath.row]
            viewCont.isEditMode = false
            viewCont.editBlogURL = Constants.URLs.saveBlog
            viewCont.deleteBlogUrl = Constants.URLs.deleteBlog
            viewCont.createBlogImageUploadUrl = Constants.URLs.createBlogImageUploadURL
            viewCont.getBlogImageUrl = Constants.URLs.getBlogImageUrl
            if let blogId = blogs[indexPath.row].id{
                viewCont.getBlogCommentCountUrl = Constants.URLs.getBlogCommentCount + blogId
            }
            viewCont.delegate = self
            self.getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension BlogsListViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let _ = self.blogManager.cursor else {
            // no more blog list present on server
            return
        }
        if let visibleIndex = blogsTableView.indexPathsForVisibleRows?.last?.row{
            if (visibleIndex % (pageSize-1)) < 3 && !self.isRequestSent{
                self.showLoaderInTableFootor()
                self.getBlogsFromServer(showLoader: false)
            }
        }

    }
}


// MARK: - UITableViewDelegate
extension BlogsListViewController: BlogListTableViewCellDelegate{
    func deleteSelectionButtonTapped(_ isSelectedForDelete: Bool) {
        // TODO work when blog is seletected for deletion also add a check to enable disable delete button
        isSelectedForDelete ? (self.totalItemsSelectedForDelete += 1) : (self.totalItemsSelectedForDelete -= 1)
        if totalItemsSelectedForDelete > 0{
            self.deleteButton.isEnabled = true
        }else{
            self.deleteButton.isEnabled = false
        }
    }
}
extension BlogsListViewController: AddNewBlogControllerDelegate{
    func addedNewBlog() {
        blogManager.cursor = ""
        blogs.removeAll()
    }
}
extension BlogsListViewController: BlogViewControllerDelegate{
    func updatedExistingBlog() {
        blogManager.cursor = ""
        blogs.removeAll()
    }
}
