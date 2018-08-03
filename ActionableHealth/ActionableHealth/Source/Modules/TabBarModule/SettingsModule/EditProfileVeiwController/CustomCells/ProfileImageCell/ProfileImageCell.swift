//
//  ProfileImageCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
protocol ProfileImageCellDelegate:NSObjectProtocol {
    func dataUpdated()
}

class ProfileImageCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!

    //MARK:- Variables
    weak var delegate:ProfileImageCellDelegate?
    var currentUser:UserModel?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

//MARK:- Additional methods
extension ProfileImageCell{
    func configureForEditProfileCell(_ user:UserModel?) {
        editButton.isHidden = false
        currentUser = user

        if let image = currentUser?.image {
            profileImage.image = image
        }else if let image = currentUser?.profileImage{
            profileImage.sd_setImage(with: URL(string: image) ?? URL.init(string: ""))
        }
    }

    @IBAction func editAction(_ sender: AnyObject) {
        UIImagePickerController.showPickerWithDelegate(self)
    }
}

//MARK:- UIImagePickerControllerDelegate
extension ProfileImageCell:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        delegate?.dataUpdated()
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            currentUser?.image = image
        }
        imagePickerControllerDidCancel(picker)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
