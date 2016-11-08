//
//  SearchViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class SearchViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var clctView: StaggeredCollectionView!
    @IBOutlet weak var srchBar: UISearchBar!

    //MARK:- Variables
    var nextUrl = ""
    var searchString = ""

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("SEARCH", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.Cross)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension SearchViewController{

    func setupView() {
        setNavigationBarBackgroundColor(UIColor.whiteColor())
        
        clctView.commonCollectionViewDelegate = self
        clctView.dataArray = NSMutableArray()
        clctView.type = CollectionViewType.HomeView
        clctView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)

        srchBar.becomeFirstResponder()
    }

    func reset() {
        clctView.dataArray.removeAllObjects()
        clctView.reloadContent()
        nextUrl = ""
        getData(0)
    }
}

//MARK:- Button Actions
extension SearchViewController{
    override func crossButtonAction(sender: UIButton?) {
        super.crossButtonAction(sender)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK:- CommonCollectionViewDelegate
extension SearchViewController:CommonCollectionViewDelegate{
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

//MARK:- UISearchBarDelegate
extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let text = searchBar.text?.getValidObject() where NetworkClass.isConnected(false) {
            showLoader()
            searchString = text
            getData(0)
        }
    }
}
//MARK:- Network Methods
extension SearchViewController{

    func getData(withShift:Int, url:String = Constants.URLs.allTemplates) {
        if NetworkClass.isConnected(true){
//            if clctView.dataArray.count == 0 {
//                showLoader()
//            }
            NetworkClass.sendRequest(URL:url, RequestType: .POST, Parameters: TemplatesModel.getPayloadDict(withShift,query: searchString), Headers: nil, CompletionHandler: {
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