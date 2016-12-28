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

    func configureForTrackMemberCell(obj:UserModel) {
        placeholderImageView.image = UIImage(named: "circle-user-ic")
        circularImageView.image = nil
        if let url = NSURL(string:obj.profileImage ?? ""){
            circularImageView.sd_setImageWithURL(url)
        }
        if let name = obj.name {
            titleDescLabel.text = name
            subTitleDescLabel.text = obj.userID
        }else{
            titleDescLabel.text = obj.userID
            subTitleDescLabel.text = nil
        }
    }

}
