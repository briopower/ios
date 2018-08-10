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
    }
    
    // MARK: - UserDefinedfunctions
    
    
    
    // MARK: - BarButtonActions
    
    // MARK: - BarButtonActions
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
                self.cancelBarButtonTapped()
                self.dismiss(animated: true, completion: nil)
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
        journalListTableView.estimatedRowHeight = UITableViewAutomaticDimension
        journalListTableView.dataSource = self
        journalListTableView.delegate = self
        
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
}
// MARK: - UITableViewDataSource
extension JournalListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JournalListTableViewCell.cellIdentifier, for: indexPath) as! JournalListTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.isEdtingMode = self.isDeleteModeOn
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
        // TODO work here when Journal is viewed
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.showAddJournalView) as? ShowAddJournalViewController{
            // TODO pass necessary thing to next controller such as pass Journal details
            viewCont.isEditing = false
            viewCont.isNewJournal = false
            self.getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}

// MARK: - JournalListTableViewCellDelegate
extension JournalListViewController: JournalListTableViewCellDelegate{

    func deleteSelectionButtonTapped() {
        // code here when journal is seleceted
        
    }
}
