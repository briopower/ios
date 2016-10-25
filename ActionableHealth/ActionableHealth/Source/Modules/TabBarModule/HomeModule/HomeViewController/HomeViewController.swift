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

    //MARK:- Variables
    var nextUrl = ""

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if NSUserDefaults.isLoggedIn() {
            self.setNavigationBarWithTitle("HOME", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.Search_Notification)
        }else{
            self.setNavigationBarWithTitle("HOME", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.Search)
        }
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
        CommonMethods.addShadowToTabBar(self.tabBarController?.tabBar)
        setNavigationBarBackgroundColor(UIColor.whiteColor())
        CommonMethods.addShadowToView(buttonsContainer)

        clctView.commonCollectionViewDelegate = self
        clctView.dataArray = NSMutableArray()
        clctView.type = CollectionViewType.HomeView
        clctView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        getData(clctView.dataArray.count)
    }

    func reset() {
        clctView.dataArray.removeAllObjects()
        clctView.reloadContent()
        nextUrl = ""
        getData(0)
    }
}
//MARK:- CommonCollectionViewDelegate
extension HomeViewController:CommonCollectionViewDelegate{
    func topElements(view: UIView) {
        getData(0)
    }

    func bottomElements(view: UIView) {
        getData(clctView.dataArray.count, url: nextUrl)
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
            print("Clicked at index \(tappedAtIndex)")
        }
    }
}

//MARK:- Network Methods
extension HomeViewController{

    func getData(withShift:Int, url:String = Constants.URLs.allTemplates) {
        if NetworkClass.isConnected(true){
            if clctView.dataArray.count == 0 {
                showLoader()
            }
            NetworkClass.sendRequest(URL:url, RequestType: .POST, Parameters: TemplatesModel.getPayloadDict(withShift), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if status{
                    self.processResponse(responseObj, withShift: withShift)
                }else{
                    self.processError(error)
                }
                self.hideLoader()
            })
        }
    }

    func processResponse(responseObj:AnyObject?, withShift:Int) {

        if let dict = responseObj {
            if withShift == 0 {
                clctView.dataArray.removeAllObjects()
            }
            let templatesArr = TemplatesModel.getResponseArray(dict)
            for obj in templatesArr {
                let template = TemplatesModel.getTemplateObj(obj)
                clctView.dataArray.addObject(template)
            }
            if let url = TemplatesModel.getNextUrl(dict){
                nextUrl = url
                clctView.hasMoreData = true
            }else{
                nextUrl = ""
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