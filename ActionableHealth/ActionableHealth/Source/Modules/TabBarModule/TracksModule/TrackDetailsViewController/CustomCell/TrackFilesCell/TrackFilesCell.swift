//
//  TrackFilesCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TrackFilesCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var detailsLabel: UILabel!

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
extension TrackFilesCell{
    func configCell(type:TrackDetailsAboutPhaseCellTypes) {
        switch type {
        case .About:
            detailsLabel.text = "About"
        case .Phases:
            detailsLabel.text = "Phases"
        default:
            break
        }
    }

    func configCell(type:TrackDetailsMemberFilesCellTypes) {
        switch type {
        case .Members:
            detailsLabel.text = "Track Members"
        case .Files:
            detailsLabel.text = "Track Files"
        default:
            break
        }
    }
}
