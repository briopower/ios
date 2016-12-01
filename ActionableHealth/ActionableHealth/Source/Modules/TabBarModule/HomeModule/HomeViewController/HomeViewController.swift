//
//  HomeViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 07/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class HomeViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var clctView: StaggeredCollectionView!
    @IBOutlet var titleView: UIImageView!

    //MARK:- Variables
    var cursor = ""

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if NSUserDefaults.isLoggedIn() {
            setNavigationBarWithTitleView(titleView, LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.Search_Notification)
        }else{
            setNavigationBarWithTitleView(titleView, LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.Search)
        }
        getData(cursor)
    }
    override func viewDidAppear(animated: Bool) {
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
        let width = (235/1242) * UIDevice.width()
        titleView.frame = CGRect(x: 0, y: 0, width: width, height:(75/235) * width)
        CommonMethods.addShadowToTabBar(self.tabBarController?.tabBar)
        CommonMethods.addShadowToView(buttonsContainer)

        clctView.commonCollectionViewDelegate = self
        clctView.dataArray = NSMutableArray()
        clctView.type = CollectionViewType.HomeView
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
    func topElements(view: UIView) {
        getData("")
    }

    func bottomElements(view: UIView) {
        getData(cursor)
    }

    func clickedAtIndexPath(indexPath: NSIndexPath, object: AnyObject) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackDetailsView) as? TrackDetailsViewController {
            dispatch_async(dispatch_get_main_queue(), {
                viewCont.sourceType = TrackDetailsSourceType.Home
                viewCont.currentTemplate = object as? TemplatesModel
                self.navigationController?.pushViewController(viewCont, animated: true)
            })
        }
    }
}
//MARK:- Button Action
extension HomeViewController{
    override func searchButtonAction(sender: UIButton?) {
        super.searchButtonAction(sender)
        if let viewCont = UIStoryboard(name: Constants.Storyboard.HomeStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.HomeStoryboard.searchView) as? UINavigationController {
            UIViewController.getTopMostViewController()?.presentViewController(viewCont, animated: true, completion: nil)
        }
    }
    override func notificationButtonAction(sender: UIButton?) {
        super.notificationButtonAction(sender)
        if let viewCont = UIStoryboard(name: Constants.Storyboard.HomeStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.HomeStoryboard.notificationNavigationView) as? UINavigationController {
            UIViewController.getTopMostViewController()?.presentViewController(viewCont, animated: true, completion: nil)
        }
    }
    @IBAction func filterAction(sender: UIButton) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.HomeStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.HomeStoryboard.filtersView) as? FiltersViewController {
            UIViewController.getTopMostViewController()?.presentViewController(viewCont, animated: true, completion: nil)
        }
    }
    @IBAction func sortAction(sender: UIButton) {
        UIAlertController.showAlertOfStyle(.ActionSheet, Title: nil, Message: nil, OtherButtonTitles: ["NEAR BY LOCATION", "RATING (HIGH TO LOW)"], CancelButtonTitle: "CANCEL") { (tappedAtIndex) in
            debugPrint("Clicked at index \(tappedAtIndex)")
        }
    }
}

//MARK:- Network Methods
extension HomeViewController{

    func getData(cursorVal:String) {
        if NetworkClass.isConnected(true){
            if clctView.dataArray.count == 0 {
                showLoader()
            }
            NetworkClass.sendRequest(URL:Constants.URLs.allTemplates, RequestType: .POST, Parameters: TemplatesModel.getPayloadDict(cursorVal), Headers: nil, CompletionHandler: {
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

    func processResponse(responseObj:AnyObject?, cursorVal:String) {

        if let dict = responseObj {
            if cursorVal == "" {
                clctView.dataArray.removeAllObjects()
            }
            let templatesArr = TemplatesModel.getTemplateResponseArray(dict)
            for obj in templatesArr {
                let template = TemplatesModel.getTemplateObj(obj)
                clctView.dataArray.addObject(template)
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

    func processError(error:NSError?) {
        
    }
}