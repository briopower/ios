//
//  SettingsViewCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum SettingsCellType:Int {
    case edit_Profile, notification, separator1, terms_Conditions,  about_Us, count

    func getConfig() -> (title:String , imageName:String, hideSideArrow:Bool) {
        switch self {
        case .edit_Profile:
            return ("Edit Profile", "message", false)
        case .notification:
            return ("Notification", "notificationSettings", true)
        case .terms_Conditions:
            return ("Terms & Conditions", "t&c", false)
//        case .Privacy_Policy:
//            return ("Privacy Policy", "password", false)
        case .about_Us:
            return ("About Us", "about-us", false)
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
    @IBOutlet weak var toggleSwitch: UISwitch!

    //MARK:- Variables
    var user = UserModel.getCurrentUser()
    var previousState = false

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK:- Additional methods
extension SettingsViewCell{
    @IBAction func toggled(_ sender: UISwitch) {
        user.enableNotifications = sender.isOn ?? false
        updateProfile()
    }
    
    func configureCellForType(_ type:SettingsCellType) {
        let (title, imageName, hideSideArrow) = type.getConfig()
        titleDescLabel.text = title
        detailsImageView.image = UIImage(named: imageName)
        sideArrow.isHidden = hideSideArrow
        toggleSwitch.isHidden = !hideSideArrow
        updateCurrentStatus()
    }

    func updateCurrentStatus() {
        user = UserModel.getCurrentUser()
        toggleSwitch.isOn = user.enableNotifications
        previousState = user.enableNotifications
    }
}

//MARK:- Network Methods
extension SettingsViewCell{
    func updateProfile() {
        if NetworkClass.isConnected(true) {
            NetworkClass.sendRequest(URL: Constants.URLs.updateMyProfile, RequestType: .post, ResponseType: .json, Parameters: user.getUpdateProfileDictionary() as AnyObject, CompletionHandler: { (status, responseObj, error, statusCode) in
                if !status{
                    self.toggleSwitch.isOn = self.previousState
                }else{
                    UserDefaults.saveUser(responseObj)
                    self.updateCurrentStatus()
                }
            })
        }
    }
}
