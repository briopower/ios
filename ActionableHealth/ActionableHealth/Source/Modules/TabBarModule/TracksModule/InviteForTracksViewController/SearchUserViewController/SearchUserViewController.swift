//
//  SearchUserViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 09/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class SearchUserViewController: CommonViewController {
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- Variables
    var searchString = ""
    var trackId = ""
    var cursor = ""
    var contactsSelected:NSMutableArray = []
    var searchResult:NSMutableArray = []
    var currentTemplate:TemplatesModel?
    var delegate:InviteForTrackViewController?
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Search User", LeftButtonType: BarButtontype.Cross, RightButtonType: BarButtontype.Done)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Actions
extension SearchUserViewController{
    override func doneButtonAction(sender: UIButton?) {
        super.doneButtonAction(sender)
        delegate?.selectedUsers = contactsSelected
        delegate?.tblView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func crossButtonAction(sender: UIButton?) {
        super.crossButtonAction(sender)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK:- Additonal methods
extension SearchUserViewController{
    func setupView() {
        setNavigationBarBackgroundColor(UIColor.whiteColor())
        srchBar.becomeFirstResponder()
        tblView.registerNib(UINib(nibName: String(ContactDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ContactDetailsCell))
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 80
    }
}

//MARK:- UISearchBarDelegate
extension SearchUserViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let text = searchBar.text?.getValidObject() where NetworkClass.isConnected(false) {
            showLoader()
            searchString = text
            searchResult.removeAllObjects()
            getData("")
        }
    }
}

//MARK:- Datasource
extension SearchUserViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(ContactDetailsCell)) as? ContactDetailsCell {
            if let obj = searchResult[indexPath.row] as? UserModel{
                cell.configCellForSearch(obj, shouldSelect: contactsSelected.containsObject(obj.userID ?? ""),isMember:currentTemplate?.isMemberOfTemplate(obj.userID ?? "") ?? false)
            }
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- Delegate
extension SearchUserViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let obj = (searchResult[indexPath.row] as? UserModel)?.userID {
            contactsSelected.containsObject(obj) ? contactsSelected.removeObject(obj) :contactsSelected.addObject(obj)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
            }

}

//MARK:- Network Methods
extension SearchUserViewController{
    
    func getData(cursorVal:String) {
        if NetworkClass.isConnected(true){
            NetworkClass.sendRequest(URL:Constants.URLs.searchUser, RequestType: .POST, Parameters: TemplatesModel.getSearchUserDict(cursor ,query: searchString), Headers: nil, CompletionHandler: {
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
    
    func processResponse(responseObj:AnyObject?, cursorVal:String) {
        let userResultSet  = responseObj?["userResultSet"] ?? []
        if let resultSet = userResultSet as? NSArray{
            for obj in resultSet{
                let model = UserModel.getUserObject(obj as? [String : AnyObject] ?? [:])
                searchResult.addObject(model)
            }
        }
        tblView.reloadData()
    }
    
    func processError(error:NSError?) {
        
    }
}
