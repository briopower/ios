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
        titleDescLabel.text = "Fitness Group"
        subTitleDescLabel.text = "999 Members"
        dateLabel.hidden = false
    }

    func configureForGroupMemberCell() {
        titleDescLabel.text = "Alexandra Xan"
        subTitleDescLabel.text = "Tamha, Istanbul"
        dateLabel.hidden = true
    }
}