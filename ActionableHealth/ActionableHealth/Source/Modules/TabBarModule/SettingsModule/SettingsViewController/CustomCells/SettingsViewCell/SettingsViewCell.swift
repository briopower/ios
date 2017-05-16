//
//  SettingsViewCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum SettingsCellType:Int {
    case Edit_Profile, Notification, Separator1, Terms_Conditions,  About_Us, Count

    func getConfig() -> (title:String , imageName:String, hideSideArrow:Bool) {
        switch self {
        case .Edit_Profile:
            return ("Edit Profile", "message", false)
        case .Notification:
            return ("Notification", "notificationSettings", true)
        case .Terms_Conditions:
            return ("Terms & Conditions", "t&c", false)
//        case .Privacy_Policy:
//            return ("Privacy Policy", "password", false)
        case .About_Us:
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK:- Additional methods
extension SettingsViewCell{
    @IBAction func toggled(sender: UISwitch) {
        user.enableNotifications = sender.on ?? false
        updateProfile()
    }
    
    func configureCellForType(type:SettingsCellType) {
        let (title, imageName, hideSideArrow) = type.getConfig()
        titleDescLabel.text = title
        detailsImageView.image = UIImage(named: imageName)
        sideArrow.hidden = hideSideArrow
        toggleSwitch.hidden = !hideSideArrow
        updateCurrentStatus()
    }

    func updateCurrentStatus() {
        user = UserModel.getCurrentUser()
        toggleSwitch.on = user.enableNotifications
        previousState = user.enableNotifications
    }
}

//MARK:- Network Methods
extension SettingsViewCell{
    func updateProfile() {
        if NetworkClass.isConnected(true) {
            NetworkClass.sendRequest(URL: Constants.URLs.updateMyProfile, RequestType: .POST, ResponseType: .JSON, Parameters: user.getUpdateProfileDictionary(), CompletionHandler: { (status, responseObj, error, statusCode) in
                if !status{
                    self.toggleSwitch.on = self.previousState
                }else{
                    NSUserDefaults.saveUser(responseObj)
                    self.updateCurrentStatus()
                }
            })
        }
    }
}
