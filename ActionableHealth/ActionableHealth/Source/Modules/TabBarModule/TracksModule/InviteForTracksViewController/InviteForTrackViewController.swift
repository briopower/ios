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
    case details, contacts, count
}

enum TrackInviteDetailsSectionCellType:Int {
    case search, addFromPhone, count
}

class InviteForTrackViewController: KeyboardAvoidingViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var contactSyncingView: UIVisualEffectView!
    @IBOutlet weak var doneButton: UIButton!

    //MARK:- Variables
    var frc:NSFetchedResultsController<NSFetchRequestResult>?
    var sourceType = TrackDetailsSourceType.templates
    var currentTemplate:TemplatesModel?
    var trackName:String?
    var selectedUsers = NSMutableArray()
    var searchedUsers = NSMutableArray()
    var isRequestSent = false

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ContactSyncManager.sharedInstance.syncCoreDataContacts()
        setNavigationBarWithTitle("Invite", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        updatDoneButton()
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
extension InviteForTrackViewController{
    @IBAction func doneAction(_ sender: UIButton) {
        switch sourceType {
        case .templates:
            createTrack()
        case .tracks:
            inviteMembers()
        default:
            break
        }
    }

    func contactSyncCompleted(_ notification:Notification) {
        frc = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName(String(Contact), predicate: NSPredicate(format: "id !=%@", UserDefaults.getUserId()), sectionNameKeyPath: nil, sorting: [("isAppUser", false), ("addressBook.name", true)])
        tblView.reloadData()
    }
}

//MARK:- Additional methods
extension InviteForTrackViewController{
    func setupView() {
        AppDelegate.getAppDelegateObject()?.startSyncing()

        NotificationCenter.default.addObserver(self, selector: #selector(self.contactSyncCompleted(_:)), name: NSNotification.Name(rawValue: ContactSyncManager.contactSyncCompleted), object: nil)
        tblView.register(UINib(nibName: String(describing: ContactDetailsCell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: ContactDetailsCell))
        tblView.register(UINib(nibName: String(describing: SearchByIdHeader), bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: String(describing: SearchByIdHeader))
        tblView.register(UINib(nibName: String(describing: AddFromPhoneHeader), bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: String(describing: AddFromPhoneHeader))

        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.sectionHeaderHeight = UITableViewAutomaticDimension
        tblView.estimatedSectionHeaderHeight = 80
        tblView.estimatedRowHeight = 80

        frc = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName(String(Contact), predicate: NSPredicate(format: "id !=%@", UserDefaults.getUserId()), sectionNameKeyPath: nil, sorting: [("isAppUser", false), ("addressBook.name", true)])

        selectedUsers = NSMutableArray(array: currentTemplate?.members ?? [])

    }

    func updatDoneButton() {
        switch sourceType {
        case .tracks:
            let shouldEnable = selectedUsers != currentTemplate?.members
            doneButton.isEnabled = shouldEnable
            shouldEnable ? (doneButton.alpha = 1) : (doneButton.alpha = 0.8)
        default:
            break
        }
    }
}

//MARK:- Network Methods
extension InviteForTrackViewController{
    func createTrack() {
        if NetworkClass.isConnected(true) /*&& selectedUsers.count > 0*/ && !isRequestSent {
            showLoaderOnWindow()
            self.isRequestSent = true
            NetworkClass.sendRequest(URL: Constants.URLs.createTrack, RequestType: .POST, Parameters: currentTemplate?.getCreateTrackDict(trackName, array: selectedUsers), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                self.isRequestSent = false
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
        if NetworkClass.isConnected(true) && selectedUsers.count > 0 && !isRequestSent{
            showLoaderOnWindow()
            self.isRequestSent = true
            NetworkClass.sendRequest(URL: Constants.URLs.inviteMember, RequestType: .POST, Parameters: currentTemplate?.getInviteMemberDict(selectedUsers), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                self.isRequestSent = false
                if status {
                    self.processResponse(responseObj)
                }else{
                    self.processError(error)
                }
                self.hideLoader()
            })
        }
    }

    func processResponse(_ response:AnyObject?) {
        switch sourceType {
        case .templates:
            getNavigationController()
            if let tbCont = getNavigationController()?.viewControllers[0] as? UITabBarController{
                tbCont.selectedIndex = 0
                getNavigationController()?.popToRootViewController(animated: true)
            }
        case .tracks:
            getNavigationController()?.popToRootViewController(animated: true)
        default:
            break
        }
    }

    func processError(_ error:NSError?) {
        switch sourceType {
        case .templates, .tracks:
            //UIAlertController.showAlertOfStyle(Message: "Something went wrong.", completion: nil)
            UIView.showToast("Something went wrong", theme: Theme.error)
        default:
            break
        }
    }
}
//MARK:- UITableViewDataSource
extension InviteForTrackViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return TrackInviteSectionType.count.rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let type = TrackInviteSectionType(rawValue: section) {
            switch type {
            case .details:
                return searchedUsers.count
            default:
                let count = frc?.fetchedObjects?.count ?? 0
                if count == 0 {
                    contactSyncingView.isHidden = !ContactSyncManager.sharedInstance.isSyncing
                }else{
                    contactSyncingView.isHidden = true
                }
                return count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let type = TrackInviteSectionType(rawValue: indexPath.section) {
            switch type {
            case .details:
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactDetailsCell)) as? ContactDetailsCell {
                    if let obj = searchedUsers[indexPath.row] as? UserModel{
                        cell.configCell(obj, shouldSelect: selectedUsers.contains(obj.userID ?? ""), isMember: currentTemplate?.isMemberOfTemplate(obj.userID ?? "") ?? false)
                        return cell
                    }
                }
            default:
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactDetailsCell)) as? ContactDetailsCell {
                    if let obj = frc?.fetchedObjects?[indexPath.row] as? Contact{
                        cell.configCell(obj, shouldSelect: selectedUsers.contains(obj.id ?? ""), isMember: currentTemplate?.isMemberOfTemplate(obj.id ?? "") ?? false)
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let type = TrackInviteSectionType(rawValue: section) {
            switch type {
            case .details:
                if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: SearchByIdHeader)) as? SearchByIdHeader {
                    headerView.delegate = self
                    return headerView
                }
            case .contacts:
                if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: AddFromPhoneHeader)) as? AddFromPhoneHeader {
                    return headerView
                }
            default:
                break
            }
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = TrackInviteSectionType(rawValue: indexPath.section) {
            switch type {
            case .details:
                if let obj = (searchedUsers[indexPath.row] as? UserModel)?.userID {
                    if UserDefaults.getUserId() == obj {
                        return
                    }
                    selectedUsers.contains(obj) ? selectedUsers.remove(obj) :selectedUsers.add(obj)
                }
            case .contacts:
                if let obj = frc?.fetchedObjects?[indexPath.row] as? Contact {
                    if let id = obj.id, let isAppUser = obj.isAppUser {
                        if UserDefaults.getUserId() == id || !isAppUser.boolValue{
                            return
                        }
                        selectedUsers.contains(id) ? selectedUsers.remove(id) :selectedUsers.add(id)
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
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.searchUserView) as? SearchUserViewController {
            viewCont.contactsSelected = NSMutableArray(array: selectedUsers)
            viewCont.searchedUsers = NSMutableArray(array: searchedUsers)
            viewCont.currentTemplate = currentTemplate
            viewCont.delegate = self
            UIViewController.getTopMostViewController()?.present(UINavigationController(rootViewController: viewCont), animated: true, completion: nil)
        }
    }
}
