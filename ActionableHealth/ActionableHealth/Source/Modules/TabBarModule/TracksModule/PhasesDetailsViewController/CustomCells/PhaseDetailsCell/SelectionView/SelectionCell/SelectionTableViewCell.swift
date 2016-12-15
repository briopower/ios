//
//  SelectionTableViewCell.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 10/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLbl: UILabel_FontSizeLabel!
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SelectionTableViewCell{
    func setUpcell(type:cellName){
        switch type {
        case .New:
            icon.image = UIImage.init(imageLiteral: "New")
            descriptionLbl.text = "NEW"
        case .Complete:
            icon.image = UIImage.init(imageLiteral: "Completed")
            descriptionLbl.text = "COMPLETE"
        case .Incomplete:
            icon.image = UIImage.init(imageLiteral: "In-Complete")
            descriptionLbl.text = "INCOMPLETE"
        case .InProgress:
            icon.image = UIImage.init(imageLiteral: "In-progress")
            descriptionLbl.text = "IN PROGRESS"
        default:
            break
        }
    }
}
