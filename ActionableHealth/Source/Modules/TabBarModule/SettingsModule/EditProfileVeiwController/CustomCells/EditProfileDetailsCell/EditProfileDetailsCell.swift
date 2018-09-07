//
//  EditProfileDetailsCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 17/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum EditProfileDetailsCellType:Int {
    case image, phone, nameCell, hobbies,count

    func getTitle() -> String {
        switch self {
        case .nameCell:
            return "NAME"
        case .phone:
            return "PHONE NUMBER"
        case .hobbies:
            return "HOBBIES"
        default:
            return ""
        }
    }
}

protocol EditProfileDetailsCellDelegate:NSObjectProtocol {
    func dataUpdated()
}

class EditProfileDetailsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var titleDescLabel: UILabel?
    @IBOutlet weak var firstField: UITextField?
    @IBOutlet weak var secondField: UITextField?
    @IBOutlet weak var detailsTextView: UITextView?
    @IBOutlet weak var completeSeprator: UIImageView?

    //MARK:- Variables
    weak var delegate:EditProfileDetailsCellDelegate?
    var currentUser:UserModel?
    var currentType = EditProfileDetailsCellType.count

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        let font = UIFont.getAppSemiboldFontWithSize(17)?.getDynamicSizeFont()
        detailsTextView?.font = font
        firstField?.font = font
        secondField?.font = font
        detailsTextView?.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK:- TextChangeMethods
extension EditProfileDetailsCell:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        switch currentType {
        case .hobbies:
            currentUser?.hobbies = textView.text
        default:
            break
        }
        delegate?.dataUpdated()
    }

    @IBAction func textDidChange(_ sender: UITextField) {
        switch currentType {
        case .nameCell:
            if sender == firstField {
                currentUser?.firstName = sender.text
            }else{
                currentUser?.lastName = sender.text
            }
        default:
            break
        }
        delegate?.dataUpdated()
    }
}

//MARK:- Additional methods
extension EditProfileDetailsCell{
    func configureCellForCellType(_ type:EditProfileDetailsCellType, user:UserModel?) {
        currentType = type
        currentUser = user
        completeSeprator?.isHidden = currentType != .hobbies
        titleDescLabel?.text = currentType.getTitle()

        switch currentType {
        case .nameCell:
            firstField?.isEnabled = true
            firstField?.placeholder = "First Name"
            firstField?.text = currentUser?.firstName

            secondField?.placeholder = "Last Name"
            secondField?.text = currentUser?.lastName
        case .phone:
            firstField?.isEnabled = false
            firstField?.placeholder = "Phone Number"
            if let phoneNumber = currentUser?.phoneNumber , !phoneNumber.isEmpty{
                firstField?.text = phoneNumber
            }else if let userID = currentUser?.userID , !userID.isEmpty{
                firstField?.text = userID
            }
            
        case .hobbies:
            detailsTextView?.text = currentUser?.hobbies ?? ""
        default:
            break
        }

        detailsTextView?.contentOffset = CGPoint(x: 0, y: -20)
    }
}
