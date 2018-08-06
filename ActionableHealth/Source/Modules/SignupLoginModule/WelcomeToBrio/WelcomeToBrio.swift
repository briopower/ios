//
//  WelcomeToBrio.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 06/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum WelcomeViewCellType:Int {
    case detailCell, phoneNo, next, count
}
class WelcomeToBrio: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var titleView: UIImageView!
    
    //MARK:- Variables
    var countryDict:NSDictionary?
    var phoneDetail:NSMutableDictionary = [:]
    //MARK:- Life Cycle
    override func viewDidLoad() {
        showLoginModule = false
        super.viewDidLoad()
        self.setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitleView(titleView, LeftButtonType: BarButtontype.none, RightButtonType: BarButtontype.none)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UserDefaults.isDisclaimerWatched() {
            DispatchQueue.main.async(execute: {
                if let waiverController = UIStoryboard(name: Constants.Storyboard.LoginStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.LoginStoryboard.waiverViewController) as? WaiverViewController{
                    if let navControl = UIViewController.getTopMostViewController() as? UINavigationController{
                        
                        let waiverNavController = UINavigationController.init(rootViewController: waiverController)
                        
                        navControl.present(waiverNavController, animated: false, completion: nil);
                    }
                }
            });
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



//MARK:- DataSource
extension WelcomeToBrio:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WelcomeViewCellType.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let type = WelcomeViewCellType(rawValue: indexPath.row) {
            switch type {
            case .detailCell:
                if let cell = tblView.dequeueReusableCell(withIdentifier: String(describing: DetailViewCell.self)) as? DetailViewCell {
                    return cell
                }
            case .phoneNo:
                if let cell = tblView.dequeueReusableCell(withIdentifier: String(describing: PhoneNoCell.self)) as? PhoneNoCell{
                    cell.setUPCell(countryDict , phoneDict:phoneDetail)
                    cell.delegate = self
                    return cell
                }
            case .next:
                if let cell = tblView.dequeueReusableCell(withIdentifier: String(describing: NextButtonCell.self)) as? NextButtonCell {
                    cell.delegate = self
                    return cell
                }
            default:
                break
            }
        }
      return UITableViewCell()
    }
}

//MARK:- CountryListDelegates
extension WelcomeToBrio:CountryListViewControllerDelegate{
    func selectedCountryObject(_ dict:NSDictionary){
        countryDict = dict
        phoneDetail["isdCode"] = dict[normalizedISDCode_key] as? String ?? ""
        self.tblView.reloadData()
    }
}

//MARK:- PhoneNoCellDelegate
extension WelcomeToBrio:PhoneNoCellDelegate{
    func countryCodeTapped() {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.LoginStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.LoginStoryboard.countryList) as? CountryListViewController {
            viewCont.delegate = self
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}
//MARK:- NextButtonCellDelegate
extension WelcomeToBrio:NextButtonCellDelegate{
    func nextButtonClicked() {
        UIApplication.dismissKeyboard()
        if checkPhoneDetails(){
            if NetworkClass.isConnected(true) {
                showLoader()
                NetworkClass.sendRequest(URL: Constants.URLs.requestOtp, RequestType: .post, Parameters: phoneDetail , Headers: nil, CompletionHandler: {
                    (status, responseObj, error, statusCode) in
                    self.processResponse(responseObj)
                    self.hideLoader()
                })
            }
        }
    }
}
//MARK:- Additional Functions
extension WelcomeToBrio{
    func setUpView(){
        let width = (235/1242) * UIDevice.width()
        titleView.frame = CGRect(x: 0, y: 0, width: width, height:(75/235) * width)
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 70
        tblView.register(UINib.init(nibName: String(describing: DetailViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: DetailViewCell.self))
        tblView.register(UINib.init(nibName: String(describing: NextButtonCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: NextButtonCell.self))
        tblView.register(UINib.init(nibName: String(describing: PhoneNoCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: PhoneNoCell.self))
        tblView.reloadData()

        countryDict = [normalizedISDCode_key: "1"]
        phoneDetail["isdCode"] = countryDict?[normalizedISDCode_key] as? String ?? ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterOtp"{
            if let vc = segue.destination as? EnterOtpViewController{
                vc.phoneDetail = phoneDetail
            }
            
        }
    }
    
    func checkPhoneDetails() -> Bool{
        if phoneDetail["isdCode"] != nil{
            if phoneDetail["phone"] != nil{
            }
            else{
                UIView.showToast("Please Enter Phone Number", theme: Theme.warning)
                //UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Enter Phone Number", completion: nil)
                return false
            }
        }
        else{
            UIView.showToast("Please Select Your Country", theme: Theme.warning)
         // UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Select Your Country", completion: nil)
            return false
        }
        return true
    }
}

//MARK:- ActionButton
extension WelcomeToBrio{
    func processResponse(_ responseObj:AnyObject?) {
        if let dict = responseObj as? NSDictionary{
            if dict["created"] as? Bool == true {
                self.performSegue(withIdentifier: "enterOtp", sender: self)
            }
            else if dict["exists"] as? Bool == true{
                self.performSegue(withIdentifier: "enterOtp", sender: self)
            }
            else{
                debugPrint("some error occured")
            }
        }
    }
}

