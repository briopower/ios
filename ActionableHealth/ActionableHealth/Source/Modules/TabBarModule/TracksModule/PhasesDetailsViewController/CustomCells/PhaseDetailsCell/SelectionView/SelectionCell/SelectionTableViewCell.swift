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
    func setUpcell(type:CellName){
        switch type {
        case .New:
            icon.image = UIImage.init(imageLiteral: "New")
        case .Complete:
            icon.image = UIImage.init(imageLiteral: "Completed")
        case .Incomplete:
            icon.image = UIImage.init(imageLiteral: "In-Complete")
        case .InProgress:
            icon.image = UIImage.init(imageLiteral: "In-progress")
        default:
            break
        }
        descriptionLbl.text = type.getStatus(type)
    }
}
