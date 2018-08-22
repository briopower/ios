//
//  JournalListViewController.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/10/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit

class JournalListViewController: CommonViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonBgViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonBGView: UIView!
    @IBOutlet weak var journalListTableView: UITableView!
    
    // MARK: - variables
    var currentTemplate:TemplatesModel?
    var sourceType = TrackDetailsSourceType.templates
    var isDeleteModeOn = false
    var journalManager = JournalsManager()
    var journals = [Journal]()
    let pageSize = 10
    var isRequestSent = false
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarWithTitle("Journals", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        
        let actionSheetBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "actionSheet"), style: .plain, target: self, action: #selector(actionSheetBarButtonTapped))
        getNavigationItem()?.rightBarButtonItem = actionSheetBarButton
        setUpTableView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.journalListTableView.tableFooterView?.isHidden = true
        getJournalsFromServer()
    }
    
    // MARK: - Bar button Tapped
    @objc func actionSheetBarButtonTapped(){
        let actionSheetController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheetController.addAction(UIAlertAction.init(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
            // code here for Delete Action
            self.isDeleteModeOn = !self.isDeleteModeOn
            self.dismiss(animated: true, completion: nil)
            self.journalListTableView.reloadData()
            let cancelBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "cut").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.cancelBarButtonTapped))
            self.getNavigationItem()?.rightBarButtonItem = cancelBarButton
            self.showDeleteButtonView()
            
        }))
        actionSheetController.addAction(UIAlertAction.init(title: "Add New Journal", style: .default, handler: { (action: UIAlertAction) in
            // code here for addding a new Journal
            self.dismiss(animated: true, completion: nil)
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.showAddJournalView) as? ShowAddJournalViewController{
                // TODO pass necessary thing to next controller
                //viewCont.currentTemplate = currentTemplate
                viewCont.isNewJournal = true
                viewCont.isEditing = false
                if let trackID = self.currentTemplate?.trackId{
                    viewCont.trackID = trackID
                }
                viewCont.delegate = self
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
        self.setJounalsSelectionForDeleteToFalse()
        let actionSheetBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "actionSheet"), style: .plain, target: self, action: #selector(actionSheetBarButtonTapped))
        getNavigationItem()?.rightBarButtonItem = actionSheetBarButton
        journalListTableView.reloadData()
        // TODO also set all selected Journal to false
    }

    
    // MARK: - ButtonActions
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alertTitleArray = ["OK"]
        UIAlertController.showAlertOfStyle(.alert, Title: "Delete Journals", Message: "Are you sure you want to delete selected Journals", OtherButtonTitles: alertTitleArray, CancelButtonTitle: "Cancel") { (index: Int?) in
            guard let indexOfAlert = index else {return}
            switch(indexOfAlert){
            case 0:
                // here write code of OK button tapped
                //TODO code to call delete API
                // TODO also call get For Journal API here
                // TODO below function should be called in completion block
                self.showLoader()
                
                let parameter = [
                    "toBeDeletedIds": self.getIdsOfJournalsToBEDeleted()
                ]
                NetworkClass.sendRequest(URL: Constants.URLs.deleteJournals, RequestType: .post, ResponseType: ExpectedResponseType.none, Parameters: parameter as AnyObject, Headers: nil) { (status: Bool, responseObj, error :NSError?, statusCode: Int?) in
                    
                    self.hideLoader()
                    if let code = statusCode{
                        print(String(code))
                        // get data from server if success
                    }
                    self.cancelBarButtonTapped()
                    self.dismiss(animated: true, completion: nil)
                }
                
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
    
    

}
// MARK: - extra functions
extension JournalListViewController{
    
    func setUpTableView(){
        journalListTableView.register(JournalListTableViewCell.cellNib, forCellReuseIdentifier: JournalListTableViewCell.cellIdentifier)
        journalListTableView.rowHeight = UITableViewAutomaticDimension
        journalListTableView.estimatedRowHeight = 100
        journalListTableView.dataSource = self
        journalListTableView.delegate = self
        journalListTableView.tableFooterView = UIView()
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
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.deleteButtonBgViewBottomConstraint.constant = -self.deleteButtonBGView.bounds.height
                self.view.layoutIfNeeded()
            })
        }
    }
    func getIdsOfJournalsToBEDeleted()->[String]{
        var idToBeDeleteArray = [String]()
        for journal in journals{
            
            if journal.isSelcetedForDelete && journal.id != nil{
                
                idToBeDeleteArray.append(journal.id!)
            }
        }
        return idToBeDeleteArray
    }
    func setJounalsSelectionForDeleteToFalse(){
        for journal in journals{
            if journal.isSelcetedForDelete{
                journal.isSelcetedForDelete = false
            }
        }
    }
    func getJournalsFromServer(showLoader: Bool = true){
        if !NetworkClass.isConnected(true){
            // no internet connection
            if journals.isEmpty{
                journalListTableView.setNoDataView(textColor: .getAppThemeColor(), message: Constants.NoDataViewText.journalList)
            }else{
                journalListTableView.removeNoDataView()
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
        guard let cursor = journalManager.cursor else {
            // this means there is no more journals please update suitably
            return
        }
        let parameter = [
            "cursor": cursor,
            "pageSize": String(pageSize),
            "query": "",
            "trackId": trackID
            ]
        if showLoader{
            self.showLoader()
        }
        self.isRequestSent = true
        NetworkClass.sendRequest(URL: Constants.URLs.getJournals, RequestType: .post, ResponseType: ExpectedResponseType.string, Parameters: parameter as AnyObject, Headers: nil) { (status: Bool, responseObj, error :NSError?, statusCode: Int?) in
            
            if showLoader{
                self.hideLoader()
            }else{
                self.removeLoaderFromFooter()
            }
            if let code = statusCode{
                if code == 200{
                    let responseDict = CommonMethods.getDictFromJSONString(jsonString: responseObj as? String )
                    self.journalManager = JournalsManager.initWithDict(dict: responseDict)
                    if let newJournals = self.journalManager.journalResultSet{
                        self.journals.append(contentsOf: newJournals)
                        self.journalListTableView.reloadData()
                    }
                    
                    // Adding and removing no Data view
                    if self.journals.isEmpty{
                        self.journalListTableView.setNoDataView(textColor: .getAppThemeColor(), message: Constants.NoDataViewText.journalList)
                    }else{
                        self.journalListTableView.removeNoDataView()
                    }
                    
                }else{
                    // error in request
                    debugPrint("Error in fetching Journals with status code \(String(describing: statusCode))  \(error?.localizedDescription ?? "")")
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
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: journalListTableView.bounds.width, height: CGFloat(44))
        
        self.journalListTableView.tableFooterView = spinner
        self.journalListTableView.tableFooterView?.isHidden = false
    }
    func removeLoaderFromFooter(){
        self.journalListTableView.tableFooterView = nil
        
    }
}
// MARK: - UITableViewDataSource
extension JournalListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journals.count
        // TODO add no dataview in respective tables
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JournalListTableViewCell.cellIdentifier, for: indexPath) as! JournalListTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.isEdtingMode = self.isDeleteModeOn
        cell.journal = journals[indexPath.row]
        cell.configCell()
        return cell
        
    }
}


// MARK: - UITableViewDelegate
extension JournalListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO pagination
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.showAddJournalView) as? ShowAddJournalViewController{
            // TODO pass necessary thing to next controller such as pass Journal details
            viewCont.isEditing = false
            viewCont.isNewJournal = false
            viewCont.selectedJournal = self.journals[indexPath.row]
            viewCont.delegate = self
            self.getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
    
    
}

// MARK: - UIScrollViewDelegate
extension JournalListViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let _ = journalManager.cursor else {
            // no more list present on server
            return
        }
        if let visibleIndex = journalListTableView.indexPathsForVisibleRows?.last?.row{
            if (visibleIndex % (pageSize-1)) < 3 && !self.isRequestSent{
                self.showLoaderInTableFootor()
                self.getJournalsFromServer(showLoader: false)
            }
        }
        
    }
}

// MARK: - JournalListTableViewCellDelegate
extension JournalListViewController: JournalListTableViewCellDelegate{

    func deleteSelectionButtonTapped() {
        // Note:- code here when journal is seleceted not when delete is tapped
        
    }
}

// MARK: - ShowAddJournalViewControllerDelegate
extension JournalListViewController : ShowAddJournalViewControllerDelegate{
    func savedOrUpdatedNewJournal() {
        journalManager.cursor = ""
        journals.removeAll()
    }
}
