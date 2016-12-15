//
//  ProfileImageCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class ProfileImageCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!

    //MARK:- Variables
    var currentUser:UserModel?

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
extension ProfileImageCell{
    func configureForEditProfileCell(user:UserModel?) {
        editButton.hidden = false
        currentUser = user

        if let image = currentUser?.image {
            profileImage.image = image
        }else if let image = currentUser?.profileImage{
            profileImage.sd_setImageWithURL(NSURL(string: image) ?? NSURL())
        }
    }

    @IBAction func editAction(sender: AnyObject) {
        UIImagePickerController.showPickerWithDelegate(self)
    }
}

//MARK:- UIImagePickerControllerDelegate
extension ProfileImageCell:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            currentUser?.image = image
        }
        imagePickerControllerDidCancel(picker)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
