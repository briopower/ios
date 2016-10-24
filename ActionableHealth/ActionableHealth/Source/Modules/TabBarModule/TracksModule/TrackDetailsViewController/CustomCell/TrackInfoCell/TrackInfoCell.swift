//
//  TrackInfoCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TrackInfoCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var trackDetailsLabel: UILabel!

    //MARK:- Variables
    var currentTemplate:TemplatesModel?

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
extension TrackInfoCell{
    func configCell(template:TemplatesModel?) {
        currentTemplate = template
        trackDetailsLabel.text = currentTemplate?.details
    }
}
