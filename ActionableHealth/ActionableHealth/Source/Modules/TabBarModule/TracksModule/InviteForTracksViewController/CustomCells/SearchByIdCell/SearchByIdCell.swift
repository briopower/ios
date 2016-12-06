//
//  SearchByIdCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 05/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
protocol SearchByIdCellDelegate:NSObjectProtocol {
    func searchTapped()
}
class SearchByIdCell: UITableViewCell {

    //MARK:- Variables
    weak var delegate:SearchByIdCellDelegate?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        delegate?.searchTapped()
    }
}
