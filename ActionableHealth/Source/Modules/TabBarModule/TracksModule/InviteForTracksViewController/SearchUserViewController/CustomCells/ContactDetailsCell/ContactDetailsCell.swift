//
//  ContactDetailsCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 05/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class ContactDetailsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var shadowLayer: UIButton!
    @IBOutlet weak var alreadyMemberLabel: UILabel_FontSizeLabel!
    @IBOutlet weak var inviteButton: UIButton!

    //MARK:- Variables
    var contactObj:Contact?

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
extension ContactDetailsCell{
    func configCell(_ obj:AnyObject, shouldSelect:Bool = false, isMember:Bool = false) {
        if let contact = obj as? Contact {
            contactObj = contact
            inviteButton.isHidden = contact.isAppUser?.boolValue ?? false
            nameLabel.text = contact.addressBook?.name
            numberLabel.text = contact.id
        }else if let model = obj as? UserModel {
            inviteButton.isHidden = true
            nameLabel.text = model.name
            numberLabel.text = model.userID
        }
        tickImage.isHidden = isMember ? true : !shouldSelect
        shadowLayer.isHidden = !isMember
        alreadyMemberLabel.isHidden = !isMember
    }

    @IBAction func inviteAction(_ sender: UIButton) {
        if NetworkClass.isConnected(true) {
            NetworkClass.sendRequest(URL: Constants.URLs.inviteUsersToApp, RequestType: .post, Parameters: contactObj?.getInviteMemberDict() as AnyObject, Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if status {
                    UIView.showToast("Invitation sent to \"\(self.contactObj?.id ?? "")\"", theme: Theme.success)
                }else{
                    UIView.showToast("Failed to invite \"\(self.contactObj?.id ?? "")\"", theme: Theme.error)
                }
            })
        }
    }

}
