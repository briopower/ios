//
//  EditProfileViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 17/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum viewType{
    case EditProfile , UpdateProfile
}
class EditProfileViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var editProfileTblView: UITableView!

    //MARK:- Variables
    let textViewCellName = "EditProfileDetailsCell_TextView"
    let nameViewCellName = "EditProfileDetailsCell_Name"
    var type:viewType = .EditProfile
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        switch type {
        case .EditProfile:
            setNavigationBarWithTitle("EDIT PROFILE", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
        case .UpdateProfile:
            setNavigationBarWithTitle("UPDATE PROFILE", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.skip)
        }
        
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

        editProfileTblView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0)
    }
}

//MARK:- ButtonActions
extension EditProfileViewController{
    override func skipButtonAction(sender: UIButton?) {
        super.skipButtonAction(sender)
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func updateAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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

//MARK:- UITableViewDelegate
extension EditProfileViewController:UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}
