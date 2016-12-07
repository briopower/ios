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

    //MARK:- Variables
    var frc:NSFetchedResultsController?

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("INVITE", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK:- Additional methods
extension InviteForTrackViewController{
    func setupView() {
//        edgesForExtendedLayout = .None
        tblView.registerNib(UINib(nibName: String(SearchByIdCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(SearchByIdCell))
        tblView.registerNib(UINib(nibName: String(AddFromPhoneCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(AddFromPhoneCell))
        tblView.registerNib(UINib(nibName: String(ContactDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ContactDetailsCell))

        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 80

        frc = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName(String(Contact), predicate: NSPredicate(format: "isAppUser = %@", NSNumber(bool: true)), sectionNameKeyPath: nil, sortingKey: ["addressBook.name"], isAcendingSort: true)
        frc?.delegate = self
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
                return frc?.fetchedObjects?.count ?? 0
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
                        cell.configCell(obj)
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
                debugPrint("Selected")
            }
        }
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let type = TrackInviteSectionType(rawValue: indexPath.section) {
            if type == .Contacts {
                debugPrint("Deselected")
            }
        }
    }
}


//MARK:- SearchByIdCellDelegate
extension InviteForTrackViewController:SearchByIdCellDelegate{
    func searchTapped() {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.searchUserView) as? SearchUserViewController {
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
                tblView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
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
