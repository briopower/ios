//
//  EditProfileViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 17/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum viewType{
    case EditProfile , UpdateProfile
}
class EditProfileViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var editProfileTblView: UITableView!

    //MARK:- Variables
    let textViewCellName = "EditProfileDetailsCell_TextView"
    let nameViewCellName = "EditProfileDetailsCell_Name"
    var type:viewType = .EditProfile
    var imageUploadURL:String?
    var user = UserModel.getCurrentUser()

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        switch type {
        case .EditProfile:
            setNavigationBarWithTitle("Edit Profile", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
        case .UpdateProfile:
            setNavigationBarWithTitle("Update Profile", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.skip)
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        switch type {
        case .UpdateProfile:
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

        editProfileTblView.registerNib(UINib(nibName: String(ProfileImageCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ProfileImageCell))
        editProfileTblView.registerNib(UINib(nibName: String(EditProfileDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(EditProfileDetailsCell))

        editProfileTblView.registerNib(UINib(nibName: nameViewCellName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: nameViewCellName)
        editProfileTblView.registerNib(UINib(nibName: textViewCellName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: textViewCellName)

        editProfileTblView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0)
    }
}

//MARK:- ButtonActions
extension EditProfileViewController{
    override func skipButtonAction(sender: UIButton?) {
        super.skipButtonAction(sender)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func updateAction(sender: AnyObject) {
        uploadImage()
    }
}

//MARK:- EditProfileViewController
extension EditProfileViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileDetailsCellType.Count.rawValue
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let type = EditProfileDetailsCellType(rawValue: indexPath.row) {
            switch type {
            case .Image:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(ProfileImageCell)) as? ProfileImageCell {
                    cell.configureForEditProfileCell(user)
                    return cell
                }
            case .NameCell:
                if let cell = tableView.dequeueReusableCellWithIdentifier(nameViewCellName) as? EditProfileDetailsCell {
                    cell.configureCellForCellType(type, user: user)
                    return cell
                }
            case .Hobbies:
                if let cell = tableView.dequeueReusableCellWithIdentifier(textViewCellName) as? EditProfileDetailsCell {
                    cell.configureCellForCellType(type, user: user)
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(EditProfileDetailsCell)) as? EditProfileDetailsCell {
                    cell.configureCellForCellType(type, user: user)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension EditProfileViewController:UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}

//MARK:- Network Methods
extension EditProfileViewController{
    func createImageUploadUrl(shouldUploadImage:Bool = true){
        if NetworkClass.isConnected(true) {
            NetworkClass.sendRequest(URL: "\(Constants.URLs.createUploadURL)\(NSUserDefaults.getUserId())", RequestType: .GET, ResponseType: .STRING,CompletionHandler: { (status, responseObj, error, statusCode) in
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
                    NetworkClass.sendImageRequest(URL: url, RequestType: .POST, ResponseType: .NONE, ImageData: UIImagePNGRepresentation(image), ProgressHandler: { (totalBytesSent, totalBytesExpectedToSend) in

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
            NetworkClass.sendRequest(URL: Constants.URLs.updateMyProfile, RequestType: .POST, ResponseType: .JSON, Parameters: user.getUpdateProfileDictionary(), CompletionHandler: { (status, responseObj, error, statusCode) in
                if status{
                    self.processSuccess(responseObj)
                }else{
                    self.processError(error)
                }
                self.hideLoader()
            })
        }
    }

    func processSuccess(response:AnyObject?) {
        NSUserDefaults.saveUser(response)
        switch type {
        case .UpdateProfile:
            self.dismissViewControllerAnimated(true, completion: nil)
        case .EditProfile:
            getNavigationController()?.popViewControllerAnimated(true)
        }
    }
    
    func processError(error:NSError?) {

    }
}
