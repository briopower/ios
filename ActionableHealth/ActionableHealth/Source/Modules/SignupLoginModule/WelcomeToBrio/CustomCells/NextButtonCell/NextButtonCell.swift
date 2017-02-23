//
//  NextButtonCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 16/02/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit
protocol NextButtonCellDelegate:NSObjectProtocol {
    func nextButtonClicked()
}
class NextButtonCell: UITableViewCell {

    //MARK:- Variables
    weak var delegate:NextButtonCellDelegate?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func nxtAction(sender: AnyObject) {
        delegate?.nextButtonClicked()
    }
}
