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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitleView(titleView, LeftButtonType: BarButtontype.none, RightButtonType: BarButtontype.none)
        getData("")
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
extension TracksViewController{
    func setupView() {
        let width = (235/1242) * UIDevice.width()
        titleView.frame = CGRect(x: 0, y: 0, width: width, height:(75/235) * width)
        clctView.commonCollectionViewDelegate = self
        clctView.dataArray = NSMutableArray()
        clctView.type = CollectionViewType.trackView
        clctView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    func reset() {
        clctView.dataArray.removeAllObjects()
        clctView.reloadContent()
        cursor = ""
    }
    
    @IBAction func nullCaseAction(_ sender: UIButton) {
        if let tbCont = getNavigationController()?.viewControllers[0] as? UITabBarController{
            tbCont.selectedIndex = 1
        }
    }
}

//MARK:- CommonCollectionViewDelegate
extension TracksViewController:CommonCollectionViewDelegate{
    func topElements(_ view: UIView) {
        getData("")
    }

    func bottomElements(_ view: UIView) {
        getData(cursor)
    }

    func clickedAtIndexPath(_ indexPath: IndexPath, object: AnyObject) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.trackDetailsView) as? TrackDetailsViewController {
                viewCont.sourceType = TrackDetailsSourceType.tracks
                viewCont.currentTemplate = object as? TemplatesModel
                getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}

//MARK:- Network Methods
extension TracksViewController{

    func getData(_ cursorVal:String) {
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

    func processResponse(_ responseObj:AnyObject?, cursorVal:String) {

        if let dict = responseObj {
            if cursorVal == "" {
                clctView.dataArray.removeAllObjects()
            }
            let tracksArr = TemplatesModel.getTrackResponseArray(dict)
            for obj in tracksArr {
                let track = TemplatesModel.getTrackObj(obj)
                clctView.dataArray.add(track)
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
                nullCase.isHidden = true
            }else{
                nullCase.isHidden = false
            }
        }
        clctView.reloadContent()
    }

    func processError(_ error:NSError?) {
        if UserDefaults.isLoggedIn() {
            UIView.showToast("Something went wrong", theme: Theme.error)
        }
    }
    
}
