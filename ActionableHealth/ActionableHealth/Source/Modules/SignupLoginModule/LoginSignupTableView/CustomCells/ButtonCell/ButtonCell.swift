//
//  ButtonCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum ButtonCellType:Int {
    case Login, Signup, OrSeprator, GooglePlus, Count
    func nibNameAndReuseIdentifier() -> String {
        switch self {
        case .OrSeprator:
            return "ButtonCell_OrSeperator"
        case .GooglePlus:
            return "ButtonCell_GooglePlus"
        default:
            return "ButtonCell"
        }
    }
}

protocol ButtonCellDelegate: NSObjectProtocol {
    func buttonPressed(type:ButtonCellType)
}

class ButtonCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tappableButton: UIButton!

    //MARK:- Variables
    var type = ButtonCellType.Login
    weak var delegate:ButtonCellDelegate?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

//MARK:- Button Action
extension ButtonCell{
    @IBAction func buttonAction(sender: UIButton) {
        delegate?.buttonPressed(type)
    }
}

//MARK:- Additional methods
extension ButtonCell{
    func configureForType(type:ButtonCellType) {
        self.type = type
        switch type {
        case .Login:
            tappableButton.setTitle("LOGIN", forState: .Normal)
            addShadowAndCornerRadius()
        case .Signup:
            tappableButton.setTitle("SIGN UP", forState: .Normal)
            addShadowAndCornerRadius()
        case .GooglePlus:
            tappableButton.setTitle("SIGN IN USING GOOGLE ACCOUNT", forState: .Normal)
            addShadowAndCornerRadius()
        default:
            break;
        }
    }

    func addShadowAndCornerRadius() {
        CommonMethods.addShadowToView(containerView)
        CommonMethods.setCornerRadius(tappableButton)
    }
}
