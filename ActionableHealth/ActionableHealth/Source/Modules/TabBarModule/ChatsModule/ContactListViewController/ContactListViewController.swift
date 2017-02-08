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
    var frc:NSFetchedResultsController?

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ContactSyncManager.sharedInstance.syncCoreDataContacts()
        setNavigationBarWithTitle("Contacts", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

//MARK:- Actions
extension ContactListViewController{
    func contactSyncCompleted(notification:NSNotification) {
        setupFRC(srchbar.text?.getValidObject())
    }
}

//MARK:- Additional methods
extension ContactListViewController{
    func setupView() {
        AppDelegate.getAppDelegateObject()?.startSyncing()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.contactSyncCompleted(_:)), name: ContactSyncManager.contactSyncCompleted, object: nil)
        tblView.registerNib(UINib(nibName: String(ContactDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ContactDetailsCell))

        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 80

        setupFRC(nil)

    }

    func setupFRC(searchText:String?) {
        if let text = searchText {
            frc = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName(String(Contact), predicate: NSPredicate(format: "id != %@ AND (addressBook.name contains[cd] %@ OR id contains[cd] %@)", NSUserDefaults.getUserId(), text, text), sectionNameKeyPath: nil, sorting: [("isAppUser", false), ("addressBook.name", true)])
        }else{
            frc = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName(String(Contact), predicate: NSPredicate(format: "id !=%@", NSUserDefaults.getUserId()), sectionNameKeyPath: nil, sorting: [("isAppUser", false), ("addressBook.name", true)])
        }

        tblView.reloadData()
    }
}

//MARK:- UITableViewDataSource
extension ContactListViewController:UITableViewDataSource{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactSyncingView.hidden = NSUserDefaults.getLastSyncDate() != nil
        return frc?.fetchedObjects?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier(String(ContactDetailsCell)) as? ContactDetailsCell {
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


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let obj = frc?.fetchedObjects?[indexPath.row] as? Contact {
            if obj.isAppUser?.boolValue ?? false, let id = obj.id{
                if let viewCont = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.MessagingStoryboard.messagingView) as? MessagingViewController, let person = Person.getPersonWith(id){
                    dispatch_async(dispatch_get_main_queue(), {
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
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        setupFRC(searchText.getValidObject())
    }
}
