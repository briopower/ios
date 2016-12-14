//
//  GroupsCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class GroupsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var circularImageView: UIImageView!
    @IBOutlet weak var titleDescLabel: UILabel!
    @IBOutlet weak var subTitleDescLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeholderImageView: UIImageView!

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
extension GroupsCell{
    func configureForGroupCell() {
        placeholderImageView.image = UIImage(named: "circle-group-ic")
        titleDescLabel.text = "Fitness Group"
        subTitleDescLabel.text = "999 Members"
        dateLabel.hidden = false
    }

    func configureForGroupMemberCell(obj:UserModel) {
        placeholderImageView.image = UIImage(named: "circle-user-ic")
        titleDescLabel.text = "\(obj.firstName) \(obj.lastName)"
        subTitleDescLabel.text = obj.phoneNumber
        dateLabel.hidden = true
    }
}
