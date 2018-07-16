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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Settings", LeftButtonType: BarButtontype.none, RightButtonType: BarButtontype.none)
        settingsTblView.reloadData()
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
        settingsTblView.register(UINib(nibName: String(describing: SettingsViewCell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: SettingsViewCell))
        settingsTblView.register(UINib(nibName: String(describing: SeparatorCell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: SeparatorCell))
        settingsTblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)

    }
}

//MARK:- UITableViewDataSource
extension SettingsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsCellType.count.rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let type = SettingsCellType(rawValue: indexPath.row) {
            switch type {
            case .separator1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SeparatorCell)) as? SeparatorCell {
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsViewCell)) as? SettingsViewCell {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = SettingsCellType(rawValue: indexPath.row) {
            switch type {
            case .edit_Profile:
                if let viewCont = UIStoryboard(name: Constants.Storyboard.SettingsStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.SettingsStoryboard.editProfileView) as? EditProfileViewController {
                    viewCont.type = .editProfile
                    getNavigationController()?.pushViewController(viewCont, animated: true)
                }
            case .terms_Conditions:
                if let viewCont = UIStoryboard(name: Constants.Storyboard.SettingsStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.SettingsStoryboard.termsAndConditionsView) as? TermsAndConditionsViewController {
                    getNavigationController()?.pushViewController(viewCont, animated: true)
                }
            case .about_Us:
                if let viewCont = UIStoryboard(name: Constants.Storyboard.SettingsStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.SettingsStoryboard.aboutUsShortView) as? AboutUsShortViewController {
                    getNavigationController()?.pushViewController(viewCont, animated: true)
                }

            default:
                break
            }
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
