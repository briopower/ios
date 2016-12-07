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
    //MARK:- Life Cycle
    override func viewDidLoad() {
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

//MARK:- Additional Functions
extension WelcomeToBrio{
    func setUpView(){
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 70
        showLoginModule = false
        tblView.registerNib(UINib.init(nibName: String(DetailViewCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(DetailViewCell))
        tblView.registerNib(UINib.init(nibName: String(ChooseCountryCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ChooseCountryCell))
        tblView.registerNib(UINib.init(nibName: String(PhoneNoCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(PhoneNoCell))
        tblView.reloadData()
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
                    cell.setUPCell(countryDict)
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
                    self.navigationController?.pushViewController(viewCont, animated: true)
                }

            default:
                break
            }
        }
    }
}

//MARK:- CountryListDelegates
extension WelcomeToBrio:CountryListViewControllerDelegate{
    func selectedCountryObject(dict:NSDictionary){
        countryDict = dict
        self.tblView.reloadData()
    }
}

//MARK:- ActionButton
extension WelcomeToBrio{
    @IBAction func nextBtnAction(sender: AnyObject) {
        self.performSegueWithIdentifier("enterOtp", sender: self)
    }
    
}
