//
//  InviteForTrackViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
import CoreData

enum TrackInviteSectionType:Int {
    case Details, Contacts, Count
}

enum TrackInviteDetailsSectionCellType:Int {
    case Search, AddFromPhone, Count
}

class InviteForTrackViewController: KeyboardAvoidingViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var contactSyncingView: UIVisualEffectView!
    @IBOutlet weak var doneButton: UIButton!

    //MARK:- Variables
    var frc:NSFetchedResultsController?
    var sourceType = TrackDetailsSourceType.Templates
    var currentTemplate:TemplatesModel?
    var trackName:String?
    var selectedUsers = NSMutableArray()
    var searchedUsers = NSMutableArray()

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ContactSyncManager.sharedInstance.syncCoreDataContacts()
        setNavigationBarWithTitle("Invite", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
        updatDoneButton()
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
extension InviteForTrackViewController{
    @IBAction func doneAction(sender: UIButton) {
        switch sourceType {
        case .Templates:
            createTrack()
        case .Tracks:
            inviteMembers()
        default:
            break
        }
    }

    func contactSyncCompleted(notification:NSNotification) {
        tblView.reloadData()
    }
}

//MARK:- Additional methods
extension InviteForTrackViewController{
    func setupView() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.contactSyncCompleted(_:)), name: ContactSyncManager.contactSyncCompleted, object: nil)
        tblView.registerNib(UINib(nibName: String(ContactDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ContactDetailsCell))
        tblView.registerNib(UINib(nibName: String(SearchByIdHeader), bundle: NSBundle.mainBundle()), forHeaderFooterViewReuseIdentifier: String(SearchByIdHeader))
        tblView.registerNib(UINib(nibName: String(AddFromPhoneHeader), bundle: NSBundle.mainBundle()), forHeaderFooterViewReuseIdentifier: String(AddFromPhoneHeader))

        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.sectionHeaderHeight = UITableViewAutomaticDimension
        tblView.estimatedSectionHeaderHeight = 80
        tblView.estimatedRowHeight = 80

        frc = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName(String(Contact), predicate: NSPredicate(format: "id !=%@", NSUserDefaults.getUserId()), sectionNameKeyPath: nil, sorting: [("isAppUser", false), ("addressBook.name", true)])

        selectedUsers = NSMutableArray(array: currentTemplate?.members ?? [])

    }

    func updatDoneButton() {
        //        let shouldEnable = selectedUsers != currentTemplate?.members
        //        doneButton.enabled = shouldEnable
        //        shouldEnable ? (doneButton.alpha = 1) : (doneButton.alpha = 0.8)
    }
}

//MARK:- Network Methods
extension InviteForTrackViewController{
    func createTrack() {
        if NetworkClass.isConnected(true) && selectedUsers.count > 0 {
            showLoaderOnWindow()
            NetworkClass.sendRequest(URL: Constants.URLs.createTrack, RequestType: .POST, Parameters: currentTemplate?.getCreateTrackDict(trackName, array: selectedUsers), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if status {
                    self.processResponse(responseObj)
                }else{
                    self.processError(error)
                }
                self.hideLoader()
            })
        }
    }

    func inviteMembers() {
        if NetworkClass.isConnected(true) && selectedUsers.count > 0 {
            showLoaderOnWindow()
            NetworkClass.sendRequest(URL: Constants.URLs.inviteMember, RequestType: .POST, Parameters: currentTemplate?.getInviteMemberDict(selectedUsers), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if status {
                    self.processResponse(responseObj)
                }else{
                    self.processError(error)
                }
                self.hideLoader()
            })
        }
    }

    func processResponse(response:AnyObject?) {
        switch sourceType {
        case .Templates:
            getNavigationController()
            if let tbCont = getNavigationController()?.viewControllers[0] as? UITabBarController{
                tbCont.selectedIndex = TrackDetailsSourceType.Tracks.rawValue
                getNavigationController()?.popToRootViewControllerAnimated(true)
            }
        case .Tracks:
            getNavigationController()?.popToRootViewControllerAnimated(true)
        default:
            break
        }
    }

    func processError(error:NSError?) {
        switch sourceType {
        case .Templates, .Tracks:
            //UIAlertController.showAlertOfStyle(Message: "Something went wrong.", completion: nil)
            UIView.showToast("Something went wrong", theme: Theme.Error)
        default:
            break
        }
    }
}
//MARK:- UITableViewDataSource
extension InviteForTrackViewController:UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TrackInviteSectionType.Count.rawValue
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let type = TrackInviteSectionType(rawValue: section) {
            switch type {
            case .Details:
                return searchedUsers.count
            default:
                contactSyncingView.hidden = NSUserDefaults.getLastSyncDate() != nil
                return frc?.fetchedObjects?.count ?? 0
            }
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let type = TrackInviteSectionType(rawValue: indexPath.section) {
            switch type {
            case .Details:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(ContactDetailsCell)) as? ContactDetailsCell {
                    if let obj = searchedUsers[indexPath.row] as? UserModel{
                        cell.configCell(obj, shouldSelect: selectedUsers.containsObject(obj.userID ?? ""), isMember: currentTemplate?.isMemberOfTemplate(obj.userID ?? "") ?? false)
                        return cell
                    }
                }
            default:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(ContactDetailsCell)) as? ContactDetailsCell {
                    if let obj = frc?.fetchedObjects?[indexPath.row] as? Contact{
                        cell.configCell(obj, shouldSelect: selectedUsers.containsObject(obj.id ?? ""), isMember: currentTemplate?.isMemberOfTemplate(obj.id ?? "") ?? false)
                        return cell
                    }
                }
            }
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension InviteForTrackViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let type = TrackInviteSectionType(rawValue: section) {
            switch type {
            case .Details:
                if let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(SearchByIdHeader)) as? SearchByIdHeader {
                    headerView.delegate = self
                    return headerView
                }
            case .Contacts:
                if let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(AddFromPhoneHeader)) as? AddFromPhoneHeader {
                    return headerView
                }
            default:
                break
            }
        }
        return nil
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let type = TrackInviteSectionType(rawValue: indexPath.section) {
            switch type {
            case .Details:
                if let obj = (searchedUsers[indexPath.row] as? UserModel)?.userID {
                    if NSUserDefaults.getUserId() == obj {
                        return
                    }
                    selectedUsers.containsObject(obj) ? selectedUsers.removeObject(obj) :selectedUsers.addObject(obj)
                }
            case .Contacts:
                if let obj = frc?.fetchedObjects?[indexPath.row] as? Contact {
                    if let id = obj.id, let isAppUser = obj.isAppUser {
                        if NSUserDefaults.getUserId() == id || !isAppUser.boolValue{
                            return
                        }
                        selectedUsers.containsObject(id) ? selectedUsers.removeObject(id) :selectedUsers.addObject(id)
                    }
                }
            default:
                break
            }
            updatDoneButton()
            tableView.reloadData()
        }
    }
}


//MARK:- SearchByIdCellDelegate
extension InviteForTrackViewController:SearchByIdHeaderDelegate{
    func searchTapped() {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.searchUserView) as? SearchUserViewController {
            viewCont.contactsSelected = NSMutableArray(array: selectedUsers)
            viewCont.searchedUsers = NSMutableArray(array: searchedUsers)
            viewCont.currentTemplate = currentTemplate
            viewCont.delegate = self
            UIViewController.getTopMostViewController()?.presentViewController(UINavigationController(rootViewController: viewCont), animated: true, completion: nil)
        }
    }
}
