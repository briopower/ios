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

    func getData(user:UserModel?) -> (text:String, image:UIImage?, placeholder:String, value:String?, isSecureTextEntry:Bool, keyboardType: UIKeyboardType) {
        switch self {
        case .Email:
            return ("Email", UIImage(named: "message"), "Enter email", user?.email, false, UIKeyboardType.EmailAddress)
        case .Password:
            return ("Password", UIImage(named: "password"), "Enter password", user?.password, true, UIKeyboardType.Default)
        case .ConfirmPassword:
            return ("Confirm Password", UIImage(named: "password"), "Confirm password", user?.confirmPassword, true, UIKeyboardType.Default)
        default:
            return ("", UIImage(named: ""), "", "", true, UIKeyboardType.Default)
        }
    }
}
class DetailsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var detailsValue: UITextField!

    //MARK:- Variables
    var type = DetailsScrollableTableViewCellType.Email
    weak var currentUser:UserModel?

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
        UIApplication.dismissKeyboard()
        if let viewCont = UIStoryboard(name: Constants.Storyboard.LoginStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.LoginStoryboard.forgotPasswordView) as? ForgotPasswordViewController {
            if let temp = currentUser {
                viewCont.currentUser = temp
            }
            UIViewController.getTopMostViewController()?.presentViewController(viewCont, animated: true, completion: nil)
        }
    }
}

//MARK:- Additional methods
extension DetailsCell{
    func configureCellForType(type:DetailsScrollableTableViewCellType, user:UserModel?) {
        currentUser = user
        self.type = type

        let (text, image, placeholder, value, isSecureTextEntry, keyboardType) = self.type.getData(currentUser)

        detailsLabel.text = text
        detailsImage.image = image
        detailsValue.placeholder = placeholder
        detailsValue.text = value
        detailsValue.secureTextEntry = isSecureTextEntry
        detailsValue.keyboardType = keyboardType
    }
}

//MARK:- TextChange Methods
extension DetailsCell{
    @IBAction func textDidChange(sender: UITextField) {
        let text = sender.text?.getValidObject() ?? ""
        switch self.type {
        case .Email:
            currentUser?.email = text
        case .Password:
            currentUser?.password = text
        case .ConfirmPassword:
            currentUser?.confirmPassword = text
        default:
            break
        }
    }
}