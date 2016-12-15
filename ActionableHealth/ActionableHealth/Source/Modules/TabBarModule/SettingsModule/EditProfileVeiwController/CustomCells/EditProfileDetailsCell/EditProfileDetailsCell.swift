//
//  EditProfileDetailsCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 17/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum EditProfileDetailsCellType:Int {
    case Image, Phone, NameCell, Hobbies,Count

    func getTitle() -> String {
        switch self {
        case .NameCell:
            return "NAME"
        case .Phone:
            return "PHONE NUMBER"
        case .Hobbies:
            return "HOBBIES"
        default:
            return ""
        }
    }
}

class EditProfileDetailsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var titleDescLabel: UILabel?
    @IBOutlet weak var firstField: UITextField?
    @IBOutlet weak var secondField: UITextField?
    @IBOutlet weak var detailsTextView: UITextView?
    @IBOutlet weak var completeSeprator: UIImageView?

    //MARK:- Variables
    var currentUser:UserModel?
    var currentType = EditProfileDetailsCellType.Count

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsTextView?.font = UIFont.getAppSemiboldFontWithSize(17)?.getDynamicSizeFont()
        detailsTextView?.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}

//MARK:- TextChangeMethods
extension EditProfileDetailsCell:UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        switch currentType {
        case .Hobbies:
            currentUser?.hobbies = textView.text
        default:
            break
        }
    }

    @IBAction func textDidChange(sender: UITextField) {
        switch currentType {
        case .NameCell:
            if sender == firstField {
                currentUser?.firstName = sender.text
            }else{
                currentUser?.lastName = sender.text
            }
        default:
            break
        }
    }
}

//MARK:- Additional methods
extension EditProfileDetailsCell{
    func configureCellForCellType(type:EditProfileDetailsCellType, user:UserModel?) {
        currentType = type
        currentUser = user
        completeSeprator?.hidden = currentType != .Hobbies
        titleDescLabel?.text = currentType.getTitle()

        switch currentType {
        case .NameCell:
            firstField?.enabled = true
            firstField?.text = currentUser?.firstName
            secondField?.text = currentUser?.lastName
        case .Phone:
            firstField?.enabled = false
            firstField?.text = currentUser?.phoneNumber
        case .Hobbies:
            detailsTextView?.text = currentUser?.hobbies ?? ""
        default:
            break
        }

        detailsTextView?.contentOffset = CGPoint(x: 0, y: -20)
    }
}
