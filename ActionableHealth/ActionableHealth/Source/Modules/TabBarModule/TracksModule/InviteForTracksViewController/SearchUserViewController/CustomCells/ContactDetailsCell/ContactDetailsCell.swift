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
extension ContactDetailsCell{
    func configCell(obj:AnyObject, shouldSelect:Bool = false, isMember:Bool = false) {
        if let contact = obj as? Contact {
            nameLabel.text = contact.addressBook?.name
            numberLabel.text = contact.id
        }else if let model = obj as? UserModel {
            nameLabel.text = model.name
            numberLabel.text = model.userID
        }
        tickImage.hidden = isMember ? true : !shouldSelect
        shadowLayer.hidden = !isMember
        alreadyMemberLabel.hidden = !isMember
    }
}
