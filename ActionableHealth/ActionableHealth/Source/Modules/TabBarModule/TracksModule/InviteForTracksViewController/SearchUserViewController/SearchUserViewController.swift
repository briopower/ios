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
    var searchedUsers = NSMutableArray()
    var searchResult:NSMutableArray = []
    var currentTemplate:TemplatesModel?
    weak var delegate:InviteForTrackViewController?
    var cancelButton:UIButton?

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Search User", LeftButtonType: BarButtontype.cross, RightButtonType: BarButtontype.done)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Actions
extension SearchUserViewController{
    override func doneButtonAction(_ sender: UIButton?) {
        super.doneButtonAction(sender)
        delegate?.selectedUsers = contactsSelected
        delegate?.searchedUsers = searchedUsers
        delegate?.tblView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }

    override func crossButtonAction(_ sender: UIButton?) {
        super.crossButtonAction(sender)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Additonal methods
extension SearchUserViewController{
    func setupView() {
        srchBar.becomeFirstResponder()
        tblView.register(UINib(nibName: String(describing: ContactDetailsCell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: ContactDetailsCell))
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 80

        if let subViews = srchBar.subviews.first?.subviews{
            for sub in subViews {
                if let cancelButton = sub as? UIButton{
                    self.cancelButton = cancelButton
                    self.cancelButton?.isEnabled = false
                    self.cancelButton?.setTitle("Search", for: UIControlState())
                }
            }
        }
    }
}

//MARK:- UISearchBarDelegate
extension SearchUserViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let _ = searchText.getValidObject() {
            cancelButton?.isEnabled = true
        }else{
            cancelButton?.isEnabled = false
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text?.getValidObject(), NetworkClass.isConnected(false) {
            searchBar.resignFirstResponder()
            showLoader()
            searchString = text
            searchResult.removeAllObjects()
            getData("")
        }
    }
}

//MARK:- Datasource
extension SearchUserViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactDetailsCell)) as? ContactDetailsCell {
            if let obj = searchResult[indexPath.row] as? UserModel{
                cell.configCell(obj, shouldSelect: contactsSelected.contains(obj.userID ?? ""),isMember:currentTemplate?.isMemberOfTemplate(obj.userID ?? "") ?? false)
            }
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- Delegate
extension SearchUserViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let obj = (searchResult[indexPath.row] as? UserModel)?.userID {
            if UserDefaults.getUserId() == obj {
                return
            }
            var userToRemove:UserModel?
            for user in searchedUsers {
                if let temp = user as? UserModel {
                    if temp.userID == obj {
                        userToRemove = temp
                        break
                    }
                }
            }
            if let temp = userToRemove {
                searchedUsers.remove(temp)
            }

            if contactsSelected.contains(obj) {
                contactsSelected.remove(obj)
            }else{
                if let temp = searchResult[indexPath.row] as? UserModel {
                    searchedUsers.add(temp)
                    contactsSelected.add(obj)
                }
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

}

//MARK:- Network Methods
extension SearchUserViewController{

    func getData(_ cursorVal:String) {
        if NetworkClass.isConnected(true){
            NetworkClass.sendRequest(URL:Constants.URLs.searchUser, RequestType: .post, Parameters: TemplatesModel.getSearchUserDict(cursor ,query: searchString) as AnyObject, Headers: nil, CompletionHandler: {
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

    func processResponse(_ responseObj:AnyObject?, cursorVal:String) {
        let userResultSet  = responseObj?["userResultSet"] ?? []
        if let resultSet = userResultSet as? NSArray{
            for obj in resultSet{
                let model = UserModel.getUserObject(obj as? [String : AnyObject] ?? [:])
                searchResult.add(model)
            }
        }
        tblView.reloadData()
    }
    
    func processError(_ error:NSError?) {
        UIView.showToast("Something went wrong", theme: Theme.error)
    }
}
