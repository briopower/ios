//
//  TrackMemberListViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 09/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TrackMemberListViewController: CommonViewController {

    @IBOutlet weak var tblVIew: UITableView!
    //MARK:- Variables
    var currentTemplate:TemplatesModel?
    var membersArray = NSMutableArray()

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    override func viewWillAppear(animated: Bool) {
        setNavigationBarWithTitle("Members", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additonal methods
extension TrackMemberListViewController{
    func setupView() {
        tblVIew.estimatedRowHeight = 100
        tblVIew.rowHeight = UITableViewAutomaticDimension
        tblVIew.registerNib(UINib(nibName: String(GroupsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(GroupsCell))
        getMembers()
    }

}


//MARK:- UITableViewDataSource
extension TrackMemberListViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(GroupsCell)) as? GroupsCell, let obj = membersArray[indexPath.row] as? UserModel {
            cell.configureForGroupMemberCell(obj)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension TrackMemberListViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.MessagingStoryboard.messagingView) as? MessagingViewController {
            dispatch_async(dispatch_get_main_queue(), {
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }
    }
}


//MARK:- Network Methods
extension TrackMemberListViewController{
    func getMembers() {
        if NetworkClass.isConnected(true), let id = currentTemplate?.trackId {
            showLoader()
            NetworkClass.sendRequest(URL: "\(Constants.URLs.trackMembers)\(id)", RequestType: .GET, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if status{
                    self.processResponse(responseObj)
                }else{
                    self.processError(error)
                }
                self.hideLoader()
            })
        }
    }

    func processResponse(response:AnyObject?) {
        if let arr = response as? NSArray {
            for obj in arr {
                if let dict = obj as? [String: AnyObject] {
                    membersArray.addObject(UserModel.getUserObject(dict))
                }
            }
        }
        tblVIew.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }

    func processError(error:NSError?) {

    }
}
