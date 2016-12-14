//
//  WelcomeToBrio.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 06/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum WelcomeViewCellType:Int {
    case DetailCell, ChooseCountry , PhoneNo , count
}
class WelcomeToBrio: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!
    
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
        setNavigationBarWithTitle("Welcome to BrioPOWER", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.None)
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
            case .ChooseCountry:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(ChooseCountryCell)) as? ChooseCountryCell {
                    cell.setUpCell(countryDict)
                    return cell
                }
            case .PhoneNo:
                if let cell = tblView.dequeueReusableCellWithIdentifier(String(PhoneNoCell)) as? PhoneNoCell{
                    cell.setUPCell(countryDict , phoneDict:phoneDetail)
                    return cell
                }

            default:
                break
            }
        }
      return UITableViewCell()
    }
}

//MARK:- Delegate
extension WelcomeToBrio:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let type = WelcomeViewCellType(rawValue: indexPath.row) {
            switch type {
            case .ChooseCountry:
                if let viewCont = UIStoryboard(name: Constants.Storyboard.LoginStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.LoginStoryboard.countryList) as? CountryListViewController {
                    viewCont.delegate = self
                    getNavigationController()?.pushViewController(viewCont, animated: true)
                }

            default:
                break
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
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

//MARK:- Additional Functions
extension WelcomeToBrio{
    func setUpView(){
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 70
        tblView.registerNib(UINib.init(nibName: String(DetailViewCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(DetailViewCell))
        tblView.registerNib(UINib.init(nibName: String(ChooseCountryCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ChooseCountryCell))
        tblView.registerNib(UINib.init(nibName: String(PhoneNoCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(PhoneNoCell))
        tblView.reloadData()
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
                UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Enter Phone Number", completion: nil)
                return false
            }
        }
        else{
            UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "Please Select Your Country", completion: nil)
            return false
        }
        return true
    }
}

//MARK:- ActionButton
extension WelcomeToBrio{
    @IBAction func nextBtnAction(sender: AnyObject) {
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


    func processResponse(responseObj:AnyObject?) {
        if let dict = responseObj as? NSDictionary{
            if dict["created"] as? Bool == true {
                self.performSegueWithIdentifier("enterOtp", sender: self)
            }
            else if dict["exists"] as? Bool == true{
                self.performSegueWithIdentifier("enterOtp", sender: self)
            }
            else{
                print("some error occured")
            }
        }
    }
}

