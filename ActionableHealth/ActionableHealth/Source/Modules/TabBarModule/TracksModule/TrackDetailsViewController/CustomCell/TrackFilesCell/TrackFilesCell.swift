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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Additional methods
extension TrackFilesCell{
    func configCell(_ type:TemplateSectionTypes) {
        switch type {
        case .about:
            detailsLabel.text = "About"
        case .phases:
            detailsLabel.text = "Getting Started"
        case .resources:
            detailsLabel.text = "Resources"
        default:
            break
        }
    }

    func configCell(_ type:TrackSectionTypes) {
        switch type {
        case .about:
            detailsLabel.text = "About"
        case .phases:
            detailsLabel.text = "Getting Started"
        case .resources:
            detailsLabel.text = "Resources"
        case .teamMembers:
            detailsLabel.text = "My Team"
        case .blogs:
            detailsLabel.text = "Blogs"
        case .journals:
            detailsLabel.text = "Journals"
        default:
            break
        }
    }

    func configCell(_ phase:PhasesModel) {
        detailsLabel.text = phase.phaseName
    }
    
    func configTaskCell(_ task:TasksModel) {
        detailsLabel.text = task.taskName
    }
}
