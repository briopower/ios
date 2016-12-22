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

    //MARK:- Variables
    var frc:NSFetchedResultsController?
    var sourceType = TrackDetailsSourceType.Home
    var selectedUsers = NSMutableArray()
    var currentTemplate:TemplatesModel?
    var trackName:String?

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Contact.syncCoreDataContacts()
        setNavigationBarWithTitle("Invite", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.Done)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Actions
extension InviteForTrackViewController{
    override func doneButtonAction(sender: UIButton?) {
        super.doneButtonAction(sender)
        switch sourceType {
        case .Home:
            createTrack()
        case .Tracks:
            inviteMembers()
        default:
            break
        }
    }
}

//MARK:- Additional methods
extension InviteForTrackViewController{
    func setupView() {

        tblView.registerNib(UINib(nibName: String(SearchByIdCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(SearchByIdCell))
        tblView.registerNib(UINib(nibName: String(AddFromPhoneCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(AddFromPhoneCell))
        tblView.registerNib(UINib(nibName: String(ContactDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ContactDetailsCell))

        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 80

        frc = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName(String(Contact), predicate: NSPredicate(format: "isAppUser = %@ AND id !=%@", NSNumber(bool: true), NSUserDefaults.getUserId()), sectionNameKeyPath: nil, sortingKey: ["addressBook.name"], isAcendingSort: true)
        frc?.delegate = self

        selectedUsers = NSMutableArray(array: currentTemplate?.members ?? [])
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
        case .Home, .Tracks:
            getNavigationController()?.popToRootViewControllerAnimated(true)
        default:
            break
        }
    }

    func processError(error:NSError?) {
        switch sourceType {
        case .Home, .Tracks:
            UIAlertController.showAlertOfStyle(Message: "Something went wrong.", completion: nil)
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
                return TrackInviteDetailsSectionCellType.Count.rawValue
            default:
                let rows = frc?.fetchedObjects?.count ?? 0
                if rows == 0 && NSUserDefaults.getLastSyncDate() == nil {
                    contactSyncingView.hidden = false
                }else{
                    contactSyncingView.hidden = true
                }
                return rows
            }
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let type = TrackInviteSectionType(rawValue: indexPath.section) {
            switch type {
            case .Details:
                if let cellType = TrackInviteDetailsSectionCellType(rawValue: indexPath.row) {
                    switch cellType {
                    case .Search:
                        if let cell = tableView.dequeueReusableCellWithIdentifier(String(SearchByIdCell)) as? SearchByIdCell {
                            cell.delegate = self
                            return cell
                        }
                    case .AddFromPhone:
                        if let cell = tableView.dequeueReusableCellWithIdentifier(String(AddFromPhoneCell)) as? AddFromPhoneCell {
                            return cell
                        }
                    default:
                        break
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let type = TrackInviteSectionType(rawValue: indexPath.section) {
            if type == .Contacts {
                if let obj = (frc?.fetchedObjects?[indexPath.row] as? Contact)?.id {
                    selectedUsers.containsObject(obj) ? selectedUsers.removeObject(obj) :selectedUsers.addObject(obj)
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            }
        }
    }
}


//MARK:- SearchByIdCellDelegate
extension InviteForTrackViewController:SearchByIdCellDelegate{
    func searchTapped() {
                if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.searchUserView) as? SearchUserViewController {
                    viewCont.contactsSelected = selectedUsers
                    viewCont.currentTemplate = currentTemplate
                    viewCont.delegate = self
                UIViewController.getTopMostViewController()?.presentViewController(UINavigationController(rootViewController: viewCont), animated: true, completion: nil)
                }
    }
}

// MARK: Fetched Results Controller Delegate Methods
extension InviteForTrackViewController:NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tblView.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tblView.endUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tblView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tblView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                tblView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                tblView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }

            if let newIndexPath = newIndexPath {
                tblView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
}
