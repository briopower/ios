//
//  MessageListCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 17/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class MessageListCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var unreadMessageCountButton: UIButton!
    @IBOutlet weak var bottomLine: UIImageView!

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
extension MessageListCell{
    func configureCell(isLastCell:Bool, personObj:Person) {
        var labelText = Contact.getNameForContact(personObj.personId ?? "") ?? personObj.personId ?? ""
        if let trackName = personObj.lastTrack {
            labelText += " (\(trackName))"
        }
        userNameLabel.text = labelText
        messageLabel.text = personObj.lastMessage?.message
        let count = personObj.getUnreadMessageCount()
        unreadMessageCountButton.setTitle("\(count)", forState: .Normal)
        unreadMessageCountButton.hidden = count == 0
        if let url = NSURL(string: personObj.personImage ?? "") {
            profileImageView.sd_setImageWithURL(url)
        }
        bottomLine.hidden = !isLastCell
    }
}
