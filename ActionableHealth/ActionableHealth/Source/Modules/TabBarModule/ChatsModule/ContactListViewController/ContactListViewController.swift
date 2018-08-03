//
//  ContactListViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 03/02/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit
import CoreData

class ContactListViewController: CommonViewController {
    //MARK:- Outlets
    @IBOutlet weak var srchbar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var contactSyncingView: UIVisualEffectView!

    //MARK:- Variables
    var frc:NSFetchedResultsController<NSFetchRequestResult>?

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ContactSyncManager.sharedInstance.syncCoreDataContacts()
        setNavigationBarWithTitle("Contacts", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK:- Actions
extension ContactListViewController{
    @objc func contactSyncCompleted(_ notification:Notification) {
        setupFRC(srchbar.text?.getValidObject())
    }
}

//MARK:- Additional methods
extension ContactListViewController{
    func setupView() {
        AppDelegate.getAppDelegateObject()?.startSyncing()
        NotificationCenter.default.addObserver(self, selector: #selector(self.contactSyncCompleted(_:)), name: NSNotification.Name(rawValue: ContactSyncManager.contactSyncCompleted), object: nil)
        tblView.register(UINib(nibName: String(describing: ContactDetailsCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: ContactDetailsCell.self))

        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 80

        setupFRC(nil)

    }

    func setupFRC(_ searchText:String?) {
        if let text = searchText {
            frc = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName("Contact", predicate: NSPredicate(format: "id != %@ AND (addressBook.name contains[cd] %@ OR id contains[cd] %@)", UserDefaults.getUserId(), text, text), sectionNameKeyPath: nil, sorting: [("isAppUser", false), ("addressBook.name", true)])
        }else{
            frc = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName("Contact", predicate: NSPredicate(format: "id !=%@", UserDefaults.getUserId()), sectionNameKeyPath: nil, sorting: [("isAppUser", false), ("addressBook.name", true)])
        }

        tblView.reloadData()
    }
}

//MARK:- UITableViewDataSource
extension ContactListViewController:UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = frc?.fetchedObjects?.count ?? 0
        if count == 0 {
            contactSyncingView.isHidden = !ContactSyncManager.sharedInstance.isSyncing
        }else{
            contactSyncingView.isHidden = true
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactDetailsCell.self)) as? ContactDetailsCell {
            if let obj = frc?.fetchedObjects?[indexPath.row] as? Contact{
                cell.configCell(obj)
                return cell
            }
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension ContactListViewController:UITableViewDelegate{


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let obj = frc?.fetchedObjects?[indexPath.row] as? Contact {
            if obj.isAppUser?.boolValue ?? false, let id = obj.id{
                if let viewCont = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.MessagingStoryboard.messagingView) as? MessagingViewController, let person = Person.getPersonWith(id){
                    DispatchQueue.main.async(execute: {
                        viewCont.personObj = person
                        self.getNavigationController()?.pushViewController(viewCont, animated: true)
                    })
                }
            }
        }
    }
}

//MARK:- UISearchBarDelegate
extension ContactListViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        setupFRC(searchText.getValidObject())
    }
}
