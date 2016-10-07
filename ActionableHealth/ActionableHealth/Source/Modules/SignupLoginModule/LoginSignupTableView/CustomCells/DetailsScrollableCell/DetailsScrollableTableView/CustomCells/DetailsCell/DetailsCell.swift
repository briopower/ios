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
}

//MARK:- Button Action

extension DetailsCell{
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
            detailsImage.image = UIImage(named: "message")
            detailsValue.placeholder = "Enter email"
        case .Password:
            detailsLabel.text = "Password"
            detailsImage.image = UIImage(named: "password")
            detailsValue.placeholder = "Enter password"

        case .ConfirmPassword:
            detailsLabel.text = "Confirm Password"
            detailsImage.image = UIImage(named: "password")
            detailsValue.placeholder = "Confirm password"
        default:
            break
        }
    }
}