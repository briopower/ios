//
//  ChangePasswordCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 07/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum ChangePasswordCellType:Int {
    case Old, New, Confirm, Submit, Count
    func getConfig() -> String {
        switch self {
        case .Old:
            return "Old Password"
        case .New:
            return "New Password"
        case .Confirm:
            return "Confirm Password"
        default:
            return ""
        }
    }
    
}
protocol ChangePasswordCellDelegate:NSObjectProtocol {
    func submitTapped()
}
class ChangePasswordCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var valueTextField: UITextField!
    
    //MARK:- Variables
    weak var delegate: ChangePasswordCellDelegate?
    var cellType = ChangePasswordCellType.Old
    var user = UserModel()

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
extension ChangePasswordCell{
    func configureCell(type:ChangePasswordCellType, user:UserModel) {
        cellType = type
        self.user = user
        valueTextField.placeholder = cellType.getConfig()
    }
}
//MARK:- Action
extension ChangePasswordCell{
    @IBAction func textDidChange(sender: UITextField) {
        let text = sender.text ?? ""
        switch cellType {
        case .Old:
            user.oldPassword = text
        case .New:
            user.password = text
        case .Confirm:
            user.confirmPassword = text
        default:
            break
        }
    }
    @IBAction func submitAction(sender: AnyObject) {
        delegate?.submitTapped()
    }
    
}