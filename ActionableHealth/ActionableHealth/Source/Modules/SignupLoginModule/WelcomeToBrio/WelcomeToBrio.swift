//
//  WelcomeToBrio.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 06/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum WelcomeViewCellType:Int {
    case DetailCell, PhoneNo, Next, count
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitleView(titleView, LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.None)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !NSUserDefaults.isDisclaimerWatched() {
            dispatch_async(dispatch_get_main_queue(), {
                if let waiverController = UIStoryboard(name: Constants.Storyboard.LoginStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.LoginStoryboard.waiverViewController) as? WaiverViewController{
                    if let navControl = UIViewController.getTopMostViewController() as? UINavigationController{
                        
                        let waiverNavController = UINavigationController.init(rootViewController: waiverController)
                        
                        navControl.presentViewController(waiverNavController, animated: false, completion: nil);
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WelcomeViewCellType.count.rawValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let type = WelcomeViewCellType(rawValue: indexPath.row) {
            switch type {
            case .DetailCell:
                if let cell = tblView.dequeueReusableCellWithIdentifier(String(DetailViewCell)) as? DetailViewCell {
                    return cell
                }
            case .PhoneNo:
                if let cell = tblView.dequeueReusableCellWithIdentifier(String(PhoneNoCell)) as? PhoneNoCell{
                    cell.setUPCell(countryDict , phoneDict:phoneDetail)
                    cell.delegate = self
                    return cell
                }
            case .Next:
                if let cell = tblView.dequeueReusableCellWithIdentifier(String(NextButtonCell)) as? NextButtonCell {
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
    func selectedCountryObject(dict:NSDictionary){
        countryDict = dict
        phoneDetail["isdCode"] = dict[normalizedISDCode_key] as? String ?? ""
        self.tblView.reloadData()
    }
}

//MARK:- PhoneNoCellDelegate
extension WelcomeToBrio:PhoneNoCellDelegate{
    func countryCodeTapped() {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.LoginStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.LoginStoryboard.countryList) as? CountryListViewController {
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
                NetworkClass.sendRequest(URL: Constants.URLs.requestOtp, RequestType: .POST, Parameters: phoneDetail , Headers: nil, CompletionHandler: {
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
        tblView.registerNib(UINib.init(nibName: String(DetailViewCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(DetailViewCell))
        tblView.registerNib(UINib.init(nibName: String(NextButtonCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(NextButtonCell))
        tblView.registerNib(UINib.init(nibName: String(PhoneNoCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(PhoneNoCell))
        tblView.reloadData()

        countryDict = [normalizedISDCode_key: "1"]
        phoneDetail["isdCode"] = countryDict?[normalizedISDCode_key] as? String ?? ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "enterOtp"{
            if let vc = segue.destinationViewController as? EnterOtpViewController{
                vc.phoneDetail = phoneDetail
            }
            
        }
    }
    
    func checkPhoneDetails() -> Bool{
        if phoneDetail["isdCode"] != nil{
            if phoneDetail["phone"] != nil{
            }
            else{
                UIView.showToast("Please Enter Phone Number", theme: Theme.Warning)
                //UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Enter Phone Number", completion: nil)
                return false
            }
        }
        else{
            UIView.showToast("Please Select Your Country", theme: Theme.Warning)
         // UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Select Your Country", completion: nil)
            return false
        }
        return true
    }
}

//MARK:- ActionButton
extension WelcomeToBrio{
    func processResponse(responseObj:AnyObject?) {
        if let dict = responseObj as? NSDictionary{
            if dict["created"] as? Bool == true {
                self.performSegueWithIdentifier("enterOtp", sender: self)
            }
            else if dict["exists"] as? Bool == true{
                self.performSegueWithIdentifier("enterOtp", sender: self)
            }
            else{
                debugPrint("some error occured")
            }
        }
    }
}

