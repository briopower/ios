//
//  RecievedMessageCell.swift
//  Petcomm
//
//  Created by Vidhan Nandi on 02/07/16.
//  Copyright © 2016 Freshworks. All rights reserved.
//

import UIKit

class RecievedMessageCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel_FontSizeLabel!
    @IBOutlet weak var messageLabel: UILabel_FontSizeLabel!
    @IBOutlet weak var profileIcon: UIImageView_RoundImageView!

       override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
