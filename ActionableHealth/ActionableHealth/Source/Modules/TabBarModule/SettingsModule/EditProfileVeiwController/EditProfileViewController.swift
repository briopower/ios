//
//  EditProfileViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 17/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum viewType{
    case editProfile , updateProfile
}
class EditProfileViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var editProfileTblView: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    //MARK:- Variables
    let textViewCellName = "EditProfileDetailsCell_TextView"
    let nameViewCellName = "EditProfileDetailsCell_Name"
    var type:viewType = .editProfile
    var imageUploadURL:String?
    var user = UserModel.getCurrentUser()

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch type {
        case .editProfile:
            setNavigationBarWithTitle("Edit Profile", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        case .updateProfile:
            setNavigationBarWithTitle("Update Profile", LeftButtonType: BarButtontype.none, RightButtonType: BarButtontype.skip)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch type {
        case .updateProfile:
            
            getNavigationController()?.viewControllers = [self]
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additional methods
extension EditProfileViewController{
    func setupView() {
        createImageUploadUrl(false)
        editProfileTblView.estimatedRowHeight = 200
        editProfileTblView.rowHeight = UITableViewAutomaticDimension

        editProfileTblView.register(UINib(nibName: String(describing: ProfileImageCell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: ProfileImageCell))
        editProfileTblView.register(UINib(nibName: String(describing: EditProfileDetailsCell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: EditProfileDetailsCell))

        editProfileTblView.register(UINib(nibName: nameViewCellName, bundle: Bundle.main), forCellReuseIdentifier: nameViewCellName)
        editProfileTblView.register(UINib(nibName: textViewCellName, bundle: Bundle.main), forCellReuseIdentifier: textViewCellName)

        editProfileTblView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0)
    }
}

//MARK:- ButtonActions
extension EditProfileViewController{
    override func skipButtonAction(_ sender: UIButton?) {
        super.skipButtonAction(sender)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func updateAction(_ sender: AnyObject) {
        uploadImage()
    }
}

//MARK:- EditProfileViewController
extension EditProfileViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileDetailsCellType.count.rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let type = EditProfileDetailsCellType(rawValue: indexPath.row) {
            switch type {
            case .image:
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileImageCell)) as? ProfileImageCell {
                    cell.configureForEditProfileCell(user)
                    cell.delegate = self
                    return cell
                }
            case .nameCell:
                if let cell = tableView.dequeueReusableCell(withIdentifier: nameViewCellName) as? EditProfileDetailsCell {
                    cell.configureCellForCellType(type, user: user)
                    cell.delegate = self
                    return cell
                }
            case .hobbies:
                if let cell = tableView.dequeueReusableCell(withIdentifier: textViewCellName) as? EditProfileDetailsCell {
                    cell.configureCellForCellType(type, user: user)
                    cell.delegate = self
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditProfileDetailsCell)) as? EditProfileDetailsCell {
                    cell.configureCellForCellType(type, user: user)
                    cell.delegate = self
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}

//MARK:- EditProfileDetailsCellDelegate ProfileImageCellDelegate
extension EditProfileViewController:EditProfileDetailsCellDelegate, ProfileImageCellDelegate{
    func dataUpdated() {
        updateButton.isEnabled = true
    }
}
//MARK:- UITableViewDelegate
extension EditProfileViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

//MARK:- Network Methods
extension EditProfileViewController{
    func createImageUploadUrl(_ shouldUploadImage:Bool = true){
        if NetworkClass.isConnected(true) {
            NetworkClass.sendRequest(URL: "\(Constants.URLs.createUploadURL)\(UserDefaults.getUserId())", RequestType: .get, ResponseType: .string,CompletionHandler: { (status, responseObj, error, statusCode) in
                if let str = responseObj as? String{
                    self.imageUploadURL = str
                    if shouldUploadImage{
                        self.uploadImage()
                    }
                }
            })
        }
    }

    func uploadImage() {
        if NetworkClass.isConnected(true) {
            if let url = imageUploadURL{
                if let image = user.image {
                    self.showProgressLoader()
                    NetworkClass.sendImageRequest(URL: url, RequestType: .post, ResponseType: .none, ImageData: UIImagePNGRepresentation(image), ProgressHandler: { (totalBytesSent, totalBytesExpectedToSend) in

                        let progress = CGFloat(totalBytesSent)/CGFloat(totalBytesExpectedToSend)
                        self.loader?.progress = progress

                        }, CompletionHandler: { (status, responseObj, error, statusCode) in
                            if status{
                                self.loader?.progress = 1
                                self.updateProfile()
                            }else{
                                self.processError(error)
                                self.hideLoader()
                            }
                    })
                }else{
                    self.showLoader()
                    self.updateProfile()
                }
            }else{
                createImageUploadUrl(true)
            }
        }
    }

    func updateProfile() {
        if NetworkClass.isConnected(true) {
            NetworkClass.sendRequest(URL: Constants.URLs.updateMyProfile, RequestType: .post, ResponseType: .json, Parameters: user.getUpdateProfileDictionary() as AnyObject, CompletionHandler: { (status, responseObj, error, statusCode) in
                if status{
                    self.processSuccess(responseObj)
                }else{
                    self.processError(error)
                }
                self.hideLoader()
            })
        }
    }

    func processSuccess(_ response:AnyObject?) {
        UserDefaults.saveUser(response)
        switch type {
        case .updateProfile:
            self.dismiss(animated: true, completion: nil)
        case .editProfile:
            getNavigationController()?.popViewController(animated: true)
        }
    }
    
    func processError(_ error:NSError?) {
        UIView.showToast("Something went wrong", theme: Theme.error)
    }
}
