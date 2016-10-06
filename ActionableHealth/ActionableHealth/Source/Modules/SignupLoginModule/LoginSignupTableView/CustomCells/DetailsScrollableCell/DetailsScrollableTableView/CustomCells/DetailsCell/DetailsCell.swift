//
//  DetailsCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum DetailsScrollableTableViewCellType:Int {
    case Email, Password, ConfirmPassword, Count
    func forgotPasswordAddon() -> String {
        return "DetailsCell_AdditionalImageView"
    }
}
class DetailsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var detailsValue: UITextField!

    //MARK:- Variables
    var type = DetailsScrollableTableViewCellType.Email

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK:- Action
    @IBAction func forgotPasswordAction(sender: AnyObject) {
    }
    
}


//MARK:- Additional methods
extension DetailsCell{
    func configureCellForType(type:DetailsScrollableTableViewCellType) {
        self.type = type
        switch self.type {
        case .Email:
            detailsLabel.text = "Email"
        case .Password:
            detailsLabel.text = "Password"
        case .ConfirmPassword:
            detailsLabel.text = "Confirm Password"
        default:
            break
        }
    }
}