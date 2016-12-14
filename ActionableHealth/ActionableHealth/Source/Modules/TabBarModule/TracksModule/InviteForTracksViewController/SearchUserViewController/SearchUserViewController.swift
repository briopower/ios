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
            }
}

//MARK:- UISearchBarDelegate
extension SearchUserViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let text = searchBar.text?.getValidObject() where NetworkClass.isConnected(false) {
            showLoader()
            searchString = text
            getData("")
        }
    }
}

//MARK:- Datasource
extension SearchUserViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//MARK:- Delegate
extension SearchUserViewController:UITableViewDelegate{
    
}

//MARK:- Network Methods
extension SearchUserViewController{
    
    func getData(cursorVal:String) {
        if NetworkClass.isConnected(true){
            NetworkClass.sendRequest(URL:Constants.URLs.searchUser, RequestType: .POST, Parameters: TemplatesModel.getSearchUserDict(cursor ,query: searchString , id:trackId), Headers: nil, CompletionHandler: {
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
        
    }
    
    func processError(error:NSError?) {
        
    }
}
