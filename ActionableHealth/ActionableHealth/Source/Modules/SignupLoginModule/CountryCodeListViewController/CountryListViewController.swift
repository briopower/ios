//
//  CountryListViewController.swift
//  ISD CODE GENERATOR
//
//  Created by Vidhan Nandi on 06/12/16.
//  Copyright © 2016 VNTech. All rights reserved.
//

import UIKit
let fileName = "CountryCodes"
let fileType = "plist"
let countryName_key = "CountryName"
let countryCode_key = "CountryCode"
let isdCode_key = "ISDCode"
let normalizedISDCode_key = "NormalizedISDCode"

protocol CountryListViewControllerDelegate:NSObjectProtocol {
    func selectedCountryObject(_ dict:NSDictionary)
}

class CountryListViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var srchBar: UISearchBar!

    //MARK:- Variables
    weak var delegate :CountryListViewControllerDelegate?

    let fileManager = FileManager.default
    var path = ""

    var namesDict = NSMutableDictionary()
    var codesDict = NSMutableDictionary()
    var dataSet = NSMutableArray()
    var countryArray = NSArray()
    var allCountriesArray = NSArray()

    //MARK:- LifeCycle
    override func viewDidLoad() {
        showLoginModule = false
        super.viewDidLoad()
        setupView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Select Country", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additional methods
extension CountryListViewController{

    func setupView() {
        let libraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as String
        path = libraryDirectory + "/\(fileName).\(fileType)"
        if fileManager.fileExists(atPath: path) {
            createCountryArray()
        }else{
            getNamesJson()
        }
        srchBar.returnKeyType = .done

        tblView.register(UINib(nibName: String(describing: CountryCodeListCell), bundle: nil), forCellReuseIdentifier: String(describing: CountryCodeListCell))
        tblView.tableFooterView = UIView(frame: CGRect.zero)
    }


    func createDataSet() {
        let values = NSMutableArray(array: namesDict.allValues)
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "self", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        values.sort(using: [descriptor])

        if let countryNames = NSArray(array: values) as? [String]{
            for countryName in countryNames {
                if let countryCodes = namesDict.allKeys(for: countryName) as? [String]{
                    if let countryCode = countryCodes.first {
                        if let isdCodeText = (codesDict.value(forKey: countryCode) as? String)?.getValidObject() {
                            let isdCode = isdCodeText.characters.split{$0 == " "}.map(String.init).first
                            if isdCode != nil {
                                let obj = [countryName_key : countryName,
                                           countryCode_key : countryCode,
                                           isdCode_key : isdCode!,
                                           normalizedISDCode_key : isdCode!.getNumbers()]

                                dataSet.add(obj)
                            }
                        }
                    }
                }
            }
        }
        createPlist()
    }

    func createCountryArray() {
        if let arr = NSArray(contentsOfFile: path) {
            countryArray = arr
            allCountriesArray = NSArray(array: countryArray)
        }
    }

    func createPlist() {
        dataSet.sort (comparator: { (obj1:AnyObject, obj2:AnyObject) -> ComparisonResult in
            if let dict1 = obj1 as? [String:String], let dict2 = obj2 as? [String:String]{

                // Fix for US at top
                if dict1[countryCode_key] == "US"{
                    return .orderedAscending
                }else if dict2[countryCode_key] == "US"{
                    return .orderedDescending
                }
                
                // Fix for CA at top
                if dict1[countryCode_key] == "CA"{
                    return .orderedAscending
                }else if dict2[countryCode_key] == "CA"{
                    return .orderedDescending
                }

//                if let isdCode1 = dict1[normalizedISDCode_key], let isdCode2 = dict2[normalizedISDCode_key]{
//                    let result = isdCode1.compare(isdCode2, options: NSStringCompareOptions.NumericSearch)
//                    return result
//                }

                if let countryName1 = dict1[countryName_key], let countryName2 = dict2[countryName_key]{
                    let result = countryName1.compare(countryName2)
                    return result
                }
            }
            return .orderedAscending
        } as! (Any, Any) -> ComparisonResult)
        
        let isWritten = dataSet.write(toFile: path, atomically: true)
        if isWritten {
            createCountryArray()
            tblView.reloadSections(IndexSet(integer: 0), with: .automatic)
            hideLoader()
        }
    }
}

//MARK:- UISearchBarDelegate
extension CountryListViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if let text = searchText.getValidObject() {
            let predicate = NSPredicate(format: "%K contains[cd] %@ OR %K contains[cd] %@ OR %K contains[cd] %@", countryName_key, text, countryCode_key, text, normalizedISDCode_key, text)
            countryArray = allCountriesArray.filtered(using: predicate) as NSArray
        }else{
            countryArray = allCountriesArray
        }
        tblView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
//MARK:- Network methods
extension CountryListViewController{
    func getNamesJson() {
        if NetworkClass.isConnected(true) {
            showLoader()
            NetworkClass.sendRequest(URL: Constants.URLs.countryNames, RequestType: .GET) { (status, responseObj, error, statusCode) in
                if status{
                    if let dict = responseObj as? NSDictionary{
                        self.namesDict = NSMutableDictionary(dictionary: dict)
                        self.getCodesJson()
                    }
                }
            }
        }
    }

    func getCodesJson() {
        if NetworkClass.isConnected(true) {
            NetworkClass.sendRequest(URL: Constants.URLs.countryCodes, RequestType: .GET) { (status, responseObj, error, statusCode) in
                if status{
                    if let dict = responseObj as? NSDictionary{
                        self.codesDict = NSMutableDictionary(dictionary: dict)
                        self.createDataSet()
                    }
                }
            }
        }else{
            hideLoader()
        }
    }
}

//MARK: - UITableViewDataSource
extension CountryListViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dict = countryArray[indexPath.row] as? NSDictionary, let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryCodeListCell)) as? CountryCodeListCell {
            cell.configCell(dict)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension CountryListViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dict = countryArray[indexPath.row] as? NSDictionary{
            delegate?.selectedCountryObject(dict)
        }
        getNavigationController()?.popViewController(animated: true)
    }
}

