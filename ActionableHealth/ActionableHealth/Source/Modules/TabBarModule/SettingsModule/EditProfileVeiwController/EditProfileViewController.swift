//
//  EditProfileViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 17/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class EditProfileViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var editProfileTblView: UITableView!

    //MARK:- Variables
    let textViewCellName = "EditProfileDetailsCell_TextView"
    let nameViewCellName = "EditProfileDetailsCell_Name"

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("EDIT PROFILE", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.Done)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension EditProfileViewController{
    func setupView() {
        editProfileTblView.estimatedRowHeight = 200
        editProfileTblView.rowHeight = UITableViewAutomaticDimension

        editProfileTblView.registerNib(UINib(nibName: String(ProfileImageCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ProfileImageCell))
        editProfileTblView.registerNib(UINib(nibName: String(EditProfileDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(EditProfileDetailsCell))

        editProfileTblView.registerNib(UINib(nibName: nameViewCellName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: nameViewCellName)
        editProfileTblView.registerNib(UINib(nibName: textViewCellName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: textViewCellName)

        editProfileTblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)

    }
}

//MARK:- ButtonActions
extension EditProfileViewController{
    override func doneButtonAction(sender: UIButton?) {
        super.doneButtonAction(sender)
        
    }
}
//MARK:- EditProfileViewController
extension EditProfileViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileDetailsCellType.Count.rawValue
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let type = EditProfileDetailsCellType(rawValue: indexPath.row) {
            switch type {
            case .Image:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(ProfileImageCell)) as? ProfileImageCell {
                    cell.configureForEditProfileCell()
                    return cell
                }
            case .NameCell:
                if let cell = tableView.dequeueReusableCellWithIdentifier(nameViewCellName) as? EditProfileDetailsCell {
                    cell.configureCellForCellType(type)
                    return cell
                }
            case .Interest, .Hobbies:
                if let cell = tableView.dequeueReusableCellWithIdentifier(textViewCellName) as? EditProfileDetailsCell {
                    cell.configureCellForCellType(type)
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(EditProfileDetailsCell)) as? EditProfileDetailsCell {
                    cell.configureCellForCellType(type)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}
