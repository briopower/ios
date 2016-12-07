//
//  TrackPhasesCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TrackPhasesCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var numberOfTaskLabel: UILabel!
    @IBOutlet weak var allTaskStatusLabel: UILabel!

    //MARK:- Variables
    var currentPhase:PhasesModel?

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
extension TrackPhasesCell{
    func configCell(phase:PhasesModel) {
        currentPhase = phase
        nameLabel.text = currentPhase?.phaseName ?? ""
        ratingLabel.text = "\(currentPhase?.rating ?? 0) Rating"
        if let count = currentPhase?.tasks.count{
            if count == 1 {
                numberOfTaskLabel.text = "Overall \(count) task"
            }else{
                numberOfTaskLabel.text = "Overall \(count) tasks"
            }
        }else{
            numberOfTaskLabel.text = ""
        }
        if phase.parentTemplate.objectType == ObjectType.Track{
            allTaskStatusLabel.text = "All Task Completed"
        }else{
            allTaskStatusLabel.text = ""
        }
    }
}
