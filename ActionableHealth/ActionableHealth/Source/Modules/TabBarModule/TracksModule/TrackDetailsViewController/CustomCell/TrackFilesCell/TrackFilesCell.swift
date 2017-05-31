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
    func configCell(type:TemplateSectionTypes) {
        switch type {
        case .About:
            detailsLabel.text = "About"
        case .Phases:
            detailsLabel.text = "Phases"
        case .Resources:
            detailsLabel.text = "Resources"
        default:
            break
        }
    }

    func configCell(type:TrackSectionTypes) {
        switch type {
        case .About:
            detailsLabel.text = "About"
        case .Phases:
            detailsLabel.text = "Phases"
        case .Resources:
            detailsLabel.text = "Resources"
        case .TeamMembers:
            detailsLabel.text = "My Team"
        default:
            break
        }
    }

    func configCell(phase:PhasesModel) {
        detailsLabel.text = phase.phaseName
    }
    
    func configTaskCell(task:TasksModel) {
        detailsLabel.text = task.taskName
    }
}
