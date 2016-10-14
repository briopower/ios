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

    func getTitleAndImageName() -> (title:String , imageName:String) {
        switch self {
        case .Edit_Profile:
            return ("Edit Profile", "message")
        case .Notification:
            return ("Notification", "notificationSettings")
        case .Terms_Conditions:
            return ("Terms & Conditions", "t&c")
        case .Privacy_Policy:
            return ("Privacy Policy", "password")
        case .About_Us:
            return ("About Us", "about-us")
        case .LogOut:
            return ("Log Out", "logout")
        default:
            return ("","")
        }
    }
}
class SettingsViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var titleDescLabel: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!

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
        let (title, imageName ) = type.getTitleAndImageName()
        titleDescLabel.text = title
        detailsImageView.image = UIImage(named: imageName)
    }
}
