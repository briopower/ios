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
    var cursor = ""
    var searchString = ""

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("Search", LeftButtonType: BarButtontype.none, RightButtonType: BarButtontype.cross)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension SearchViewController{

    func setupView() {        
        clctView.commonCollectionViewDelegate = self
        clctView.dataArray = NSMutableArray()
        clctView.type = CollectionViewType.templateView
        clctView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)

        srchBar.becomeFirstResponder()
    }

    func reset() {
        clctView.dataArray.removeAllObjects()
        clctView.reloadContent()
        cursor = ""
    }
}

//MARK:- Button Actions
extension SearchViewController{
    override func crossButtonAction(_ sender: UIButton?) {
        super.crossButtonAction(sender)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- CommonCollectionViewDelegate
extension SearchViewController:CommonCollectionViewDelegate{
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

//MARK:- UISearchBarDelegate
extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text?.getValidObject(), NetworkClass.isConnected(false) {
            searchBar.resignFirstResponder()
            showLoader()
            searchString = text
            getData("")
        }
    }
}
//MARK:- Network Methods
extension SearchViewController{

    func getData(_ cursorVal:String) {
        if NetworkClass.isConnected(true){
//            if clctView.dataArray.count == 0 {
//                showLoader()
//            }
            NetworkClass.sendRequest(URL:Constants.URLs.allTemplates, RequestType: .post, Parameters: TemplatesModel.getPayloadDict(cursor,query: searchString) as AnyObject as AnyObject, Headers: nil, CompletionHandler: {
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
        UIView.showToast("Something went wrong", theme: Theme.error)
    }
}
