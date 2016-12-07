//
//  InviteForTrackViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum TrackInviteSectionType:Int {
    case Details, Contacts, Count
}

enum TrackInviteDetailsSectionCellType:Int {
    case Search, AddFromPhone, Count
}

enum TrackInviteDataSourceType:Int {
    case PhoneBook, Search, Count
}
class InviteForTrackViewController: KeyboardAvoidingViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!

    //MARK:- Variables
    var dataSourceType = TrackInviteDataSourceType.PhoneBook

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
        edgesForExtendedLayout = .None
        tblView.registerNib(UINib(nibName: String(SearchByIdCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(SearchByIdCell))
        tblView.registerNib(UINib(nibName: String(AddFromPhoneCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(AddFromPhoneCell))
        tblView.registerNib(UINib(nibName: String(ContactDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ContactDetailsCell))

        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 80
    }

    func reloadAllSections(forType:TrackInviteDataSourceType) {
        
        dataSourceType = forType
        tblView.reloadSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: TrackInviteDetailsSectionCellType.Count.rawValue)), withRowAnimation: .Automatic)
        if dataSourceType == .PhoneBook {
            searchBarHeight.constant = 0

            UIView.animateWithDuration(0.3, animations: {
                self.view.layoutIfNeeded()
            }) { (finished:Bool) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.searchBar.resignFirstResponder()
                })
            }

        }else{
            searchBar.becomeFirstResponder()
            searchBarHeight.constant = 44
            UIView.animateWithDuration(0.3) {
                self.view.layoutIfNeeded()
            }
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
                return dataSourceType == .PhoneBook ? TrackInviteDetailsSectionCellType.Count.rawValue : 0
            default:
                return dataSourceType == .PhoneBook ? 10 : 5
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
                    return cell
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

//MARK:- UISearchBarDelegate
extension InviteForTrackViewController:UISearchBarDelegate{

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        debugPrint(searchText)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        reloadAllSections(.PhoneBook)
    }

}

extension InviteForTrackViewController:SearchByIdCellDelegate{
    func searchTapped() {
        reloadAllSections(.Search)
    }
}
