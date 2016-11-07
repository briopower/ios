//
//  ChangePasswordViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 04/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class ChangePasswordViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var chngPasswordTblView: UITableView!

    //MARK:- Variables
    let submitCell = "ChangePasswordCell_Submit"
    var currnetUser = UserModel()
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("CHANGE PASSWORD", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additional methods
extension ChangePasswordViewController{
    func setupView(){
        chngPasswordTblView.registerNib(UINib(nibName: String(ChangePasswordCell), bundle: nil), forCellReuseIdentifier: String(ChangePasswordCell))
        chngPasswordTblView.registerNib(UINib(nibName: submitCell, bundle: nil), forCellReuseIdentifier: submitCell)

        chngPasswordTblView.estimatedRowHeight = 80
        chngPasswordTblView.rowHeight = UITableViewAutomaticDimension
    }
}

//MARK:- ChangePasswordCellDelegate
extension ChangePasswordViewController:ChangePasswordCellDelegate{
    func submitTapped() {

        UIApplication.dismissKeyboard()
      
            if NetworkClass.isConnected(true) {
                
                showLoaderOnWindow()
                
                NetworkClass.sendRequest(URL: Constants.URLs.updateDetails, RequestType: .POST, Parameters: currnetUser.getUpdatePasswordDictionary() , Headers: nil, CompletionHandler: {
                    (status, responseObj, error, statusCode) in
                   
                    
                    if status == true {
                        if let responseDictionary = responseObj as? Dictionary<String, AnyObject>{
                            
                            if let invalidPassword = responseDictionary["invalidPassword"] as? Bool{
                                
                                if !invalidPassword
                                {
//                                    self.dismissViewControllerAnimated(true, completion: nil)
//                                    UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: responseDictionary["message"] as? String, completion: nil)
                                    
                                    UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Title: "Change Password", Message: responseDictionary["message"] as? String, OtherButtonTitles: nil, CancelButtonTitle: "ok", completion: {UIAlertAction in
                                        self.navigationController?.popViewControllerAnimated(true)})
                                
                                }
                                else{
                                    UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Title: "Change Password", Message: responseDictionary["message"] as? String, OtherButtonTitles: nil, CancelButtonTitle: "ok", completion: {UIAlertAction in
                                        self.dismissViewControllerAnimated(true, completion: nil)})
                                }
                            }
                        }
                    }
                   
                    else {
                        UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Something went wrong! Please try again", OtherButtonTitles: nil, CancelButtonTitle: "ok", completion: nil)
                    }
                    self.hideLoader()
                })
            }
        }
    

        
    }

//MARK:- UITableViewDataSource
extension ChangePasswordViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChangePasswordCellType.Count.rawValue
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let type = ChangePasswordCellType(rawValue: indexPath.row) {
            switch type {
            case .Old, .New, .Confirm:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(ChangePasswordCell)) as? ChangePasswordCell{
                    cell.configureCell(type, user: currnetUser)
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCellWithIdentifier(submitCell) as? ChangePasswordCell{
                    cell.delegate = self
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}