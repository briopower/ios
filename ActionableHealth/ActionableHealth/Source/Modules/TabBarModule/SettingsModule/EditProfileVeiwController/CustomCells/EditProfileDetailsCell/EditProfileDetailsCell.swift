//
//  EditProfileDetailsCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 17/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum EditProfileDetailsCellType:Int {
    case Image,NameCell, Phone, Title, Interest, Hobbies,Count

    func getTitle() -> String {
        switch self {
        case .NameCell:
            return "NAME"
        case .Phone:
            return "PHONE NUMBER"
        case .Title:
            return "TITLE/COMPANY"
        case .Interest:
            return "INTEREST"
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
    @IBOutlet weak var detailsTextView: UITextView?
    @IBOutlet weak var completeSeprator: UIImageView_SepratorImageView?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsTextView?.font = UIFont.getAppRegularFontWithSize(17)?.getDynamicSizeFont()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Additional methods
extension EditProfileDetailsCell{
    func configureCellForCellType(type:EditProfileDetailsCellType) {
        completeSeprator?.hidden = type != .Hobbies
        titleDescLabel?.text = type.getTitle()
        detailsTextView?.contentOffset = CGPoint(x: 0, y: -20)
    }
}
