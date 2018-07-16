//
//  HomeViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 07/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum SortTypes:Int{
    case createdDate, rating, activeTracks
    func getStringValue() -> String {
        switch  self {
        case .activeTracks:
            return "activeTracks"
        case .createdDate:
            return "createdDate"
        case .rating:
            return "rating"
        }
    }
}
class HomeViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var clctView: StaggeredCollectionView!
    @IBOutlet weak var filterBtn: UIButton!

    //MARK:- Variables
    var cursor = ""
    var sortingKey = ""
    var filterArray: [Any] = []

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupOnAppear()
    }

    func setupOnAppear() {
        setNavigationBarWithTitle("Library", LeftButtonType: BarButtontype.none2, RightButtonType: BarButtontype.search)
        getData(cursor)
        setupFilterButton()
    }

    func setupFilterButton() {
        var image:UIImage?
        if filterArray.count > 0 {
            image = UIImage(named: "filterApplied")
        }else{
            image = UIImage(named: "filter")
        }

        filterBtn.setImage(image?.withRenderingMode(.alwaysOriginal), for: UIControlState())

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension HomeViewController{
    func setupView() {
        CommonMethods.addShadowToView(buttonsContainer)

        clctView.commonCollectionViewDelegate = self
        clctView.dataArray = NSMutableArray()
        clctView.type = CollectionViewType.templateView
        clctView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }

    func reset() {
        clctView.dataArray.removeAllObjects()
        clctView.reloadContent()
        cursor = ""
    }
}
//MARK:- CommonCollectionViewDelegate
extension HomeViewController:CommonCollectionViewDelegate{
    func topElements(_ view: UIView) {
        getData("")
    }

    func bottomElements(_ view: UIView) {
        getData(cursor)
    }

    func clickedAtIndexPath(_ indexPath: IndexPath, object: AnyObject) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.trackDetailsView) as? TrackDetailsViewController {
            DispatchQueue.main.async(execute: {
                viewCont.sourceType = TrackDetailsSourceType.templates
                viewCont.currentTemplate = object as? TemplatesModel
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }
    }
}
//MARK:- Button Action
extension HomeViewController{
    override func searchButtonAction(_ sender: UIButton?) {
        super.searchButtonAction(sender)
        if let viewCont = UIStoryboard(name: Constants.Storyboard.HomeStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.HomeStoryboard.searchView) as? UINavigationController {
            UIViewController.getTopMostViewController()?.present(viewCont, animated: true, completion: nil)
        }
    }
    override func notificationButtonAction(_ sender: UIButton?) {
        super.notificationButtonAction(sender)
        if let viewCont = UIStoryboard(name: Constants.Storyboard.HomeStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.HomeStoryboard.notificationNavigationView) as? UINavigationController {
            UIViewController.getTopMostViewController()?.present(viewCont, animated: true, completion: nil)
        }
    }
    @IBAction func filterAction(_ sender: UIButton) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.HomeStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.HomeStoryboard.filtersView) as? FiltersViewController {
            viewCont.delegate = self
            viewCont.selectedFilters = filterArray
            UIViewController.getTopMostViewController()?.present(viewCont, animated: true, completion: nil)
        }
    }
    @IBAction func sortAction(_ sender: UIButton) {
        UIAlertController.showAlertOfStyle(.actionSheet, Title: nil, Message: nil, OtherButtonTitles: ["ORDER BY DATE", "RATINGS" , "ACTIVE GROUPS"], CancelButtonTitle: "CANCEL") { (tappedAtIndex) in
            debugPrint("Clicked at index \(tappedAtIndex)")
            if let key = SortTypes(rawValue: tappedAtIndex ?? 0)?.getStringValue(){
                self.sortingKey = key
            }
            self.getData(self.cursor)
        }
    }
}

//MARK:- Network Methods
extension HomeViewController{

    func getData(_ cursorVal:String) {
        if NetworkClass.isConnected(true){
            if clctView.dataArray.count == 0 {
                showLoader()
            }
            NetworkClass.sendRequest(URL:Constants.URLs.allTemplates, RequestType: .post, Parameters: TemplatesModel.getPayloadDict(cursorVal ,orderBy:sortingKey , filterByType: filterArray as NSArray) as AnyObject, Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if status{
                    self.processResponse(responseObj, cursorVal: cursorVal)
                }else{
                    self.processError(error)
                }
                self.hideLoader()
            })
        }
    }

    func processResponse(_ responseObj:AnyObject?, cursorVal:String) {

        if let dict = responseObj {
            if cursorVal == "" {
                clctView.dataArray.removeAllObjects()
            }
            let templatesArr = TemplatesModel.getTemplateResponseArray(dict)
            for obj in templatesArr {
                let template = TemplatesModel.getTemplateObj(obj as AnyObject)
                clctView.dataArray.add(template)
            }
            if let cursorVal = TemplatesModel.getCursor(dict){
                cursor = cursorVal
                clctView.hasMoreData = true
            }else{
                cursor = ""
                clctView.hasMoreData = false
            }
            clctView.removeTopLoader()
            if clctView.dataArray.count > 0 {
                clctView.addTopLoader()
            }
        }
        clctView.reloadContent()
    }

    func processError(_ error:NSError?) {
        if UserDefaults.isLoggedIn(){
            UIView.showToast("Something went wrong", theme: Theme.error)
        }
    }
}
