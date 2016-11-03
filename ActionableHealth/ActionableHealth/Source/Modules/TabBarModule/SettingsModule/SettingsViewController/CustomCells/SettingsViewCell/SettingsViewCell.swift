//
//  SettingsViewCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum SettingsCellType:Int {
    case Edit_Profile, Notification, Separator1, Terms_Conditions, Privacy_Policy, About_Us, Separator2, LogOut, Count

    func getConfig() -> (title:String , imageName:String, hideSideArrow:Bool) {
        switch self {
        case .Edit_Profile:
            return ("Edit Profile", "message", false)
        case .Notification:
            return ("Notification", "notificationSettings", false)
        case .Terms_Conditions:
            return ("Terms & Conditions", "t&c", false)
        case .Privacy_Policy:
            return ("Privacy Policy", "password", false)
        case .About_Us:
            return ("About Us", "about-us", false)
        case .LogOut:
            return ("Log Out", "logout", true)
        default:
            return ("", "", false)
        }
    }
}
class SettingsViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var titleDescLabel: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var sideArrow: UIImageView!

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK:- Additional methods
extension SettingsViewCell{
    func configureCellForType(type:SettingsCellType) {
        let (title, imageName, hideSideArrow) = type.getConfig()
        titleDescLabel.text = title
        detailsImageView.image = UIImage(named: imageName)
        sideArrow.hidden = hideSideArrow
    }
}
