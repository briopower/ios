//
//  TracksViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 07/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TracksViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var clctView: StaggeredCollectionView!
    @IBOutlet weak var nullCase: UIButton!
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
        self.setNavigationBarWithTitleView(titleView, LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.None)
        getData("")
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
extension TracksViewController{
    func setupView() {
        let width = (235/1242) * UIDevice.width()
        titleView.frame = CGRect(x: 0, y: 0, width: width, height:(75/235) * width)
        clctView.commonCollectionViewDelegate = self
        clctView.dataArray = NSMutableArray()
        clctView.type = CollectionViewType.TrackView
        clctView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    func reset() {
        clctView.dataArray.removeAllObjects()
        clctView.reloadContent()
        cursor = ""
    }
    
    @IBAction func nullCaseAction(sender: UIButton) {
        if let tbCont = getNavigationController()?.viewControllers[0] as? UITabBarController{
            tbCont.selectedIndex = 1
        }
    }
}

//MARK:- CommonCollectionViewDelegate
extension TracksViewController:CommonCollectionViewDelegate{
    func topElements(view: UIView) {
        getData("")
    }

    func bottomElements(view: UIView) {
        getData(cursor)
    }

    func clickedAtIndexPath(indexPath: NSIndexPath, object: AnyObject) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackDetailsView) as? TrackDetailsViewController {
                viewCont.sourceType = TrackDetailsSourceType.Tracks
                viewCont.currentTemplate = object as? TemplatesModel
                getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}

//MARK:- Network Methods
extension TracksViewController{

    func getData(cursorVal:String) {
        if NetworkClass.isConnected(true){
            if clctView.dataArray.count == 0 {
                showLoader()
            }
            NetworkClass.sendRequest(URL:Constants.URLs.myTracks, RequestType: .POST, Parameters: TemplatesModel.getPayloadDict(cursorVal), Headers: nil, CompletionHandler: {
                (status, responseObj, error, new ) in
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
            let tracksArr = TemplatesModel.getTrackResponseArray(dict)
            for obj in tracksArr {
                let track = TemplatesModel.getTrackObj(obj)
                clctView.dataArray.addObject(track)
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
                nullCase.hidden = true
            }else{
                nullCase.hidden = false
            }
        }
        clctView.reloadContent()
    }

    func processError(error:NSError?) {
        if NSUserDefaults.isLoggedIn() {
            UIView.showToast("Something went wrong", theme: Theme.Error)
        }
    }
    
}
