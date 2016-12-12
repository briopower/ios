//
//  SettingsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 07/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class SettingsViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var settingsTblView: UITableView!

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Settings", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.None)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension SettingsViewController{
    func setupView() {
        settingsTblView.estimatedRowHeight = 200
        settingsTblView.rowHeight = UITableViewAutomaticDimension
        settingsTblView.registerNib(UINib(nibName: String(SettingsViewCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(SettingsViewCell))
        settingsTblView.registerNib(UINib(nibName: String(SeparatorCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(SeparatorCell))
        settingsTblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)

    }
}

//MARK:- UITableViewDataSource
extension SettingsViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsCellType.Count.rawValue
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let type = SettingsCellType(rawValue: indexPath.row) {
            switch type {
            case .Separator1:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(SeparatorCell)) as? SeparatorCell {
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(SettingsViewCell)) as? SettingsViewCell {
                    cell.configureCellForType(type)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension SettingsViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let type = SettingsCellType(rawValue: indexPath.row) {
            switch type {
            case .Edit_Profile:
                if let viewCont = UIStoryboard(name: Constants.Storyboard.SettingsStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.SettingsStoryboard.editProfileView) as? EditProfileViewController {
                    viewCont.type = .EditProfile
                    self.navigationController?.pushViewController(viewCont, animated: true)
                }
            case .Notification:
                if let viewCont = UIStoryboard(name: Constants.Storyboard.HomeStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.HomeStoryboard.notificationView) as? NotificationsViewController {
                    getNavigationController()?.pushViewController(viewCont, animated: true)
                }
            default:
                break
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }
}
