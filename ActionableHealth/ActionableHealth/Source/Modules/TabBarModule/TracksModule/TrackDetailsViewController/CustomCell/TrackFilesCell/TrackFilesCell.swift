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
    func configCell(type:TrackDetailsCellTypes, sourceType:TrackDetailsSourceType) {
        switch sourceType {
        case .Templates:
            switch type {
            case .Files:
                detailsLabel.text = "Template Files"
            case .Members:
                detailsLabel.text = "Template Members"
            default:
                break
            }
        case .Tracks:
            switch type {
            case .Files:
                detailsLabel.text = "Track Files"
            case .Members:
                detailsLabel.text = "Track Members"
            default:
                break
            }
        default:
            break
        }

    }
}
