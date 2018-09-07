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
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarWithTitle("Members", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
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
        tblVIew.register(UINib(nibName: String(describing: GroupsCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: GroupsCell.self))
        getMembers()
    }

}


//MARK:- UITableViewDataSource
extension TrackMemberListViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GroupsCell.self)) as? GroupsCell, let obj = membersArray[indexPath.row] as? UserModel {
            cell.configureForTrackMemberCell(obj)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension TrackMemberListViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.MessagingStoryboard.messagingView) as? MessagingViewController, let userId = (membersArray[indexPath.row] as? UserModel)?.userID {
            if userId != UserDefaults.getUserId() {
                DispatchQueue.main.async(execute: {
                    viewCont.personObj = Person.getPersonWith(userId)
                    viewCont.trackName = self.currentTemplate?.name
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                    self.getNavigationController()?.pushViewController(viewCont, animated: true)
                })
            }
        }
    }
}


//MARK:- Network Methods
extension TrackMemberListViewController{
    func getMembers() {
        if NetworkClass.isConnected(true), let id = currentTemplate?.trackId {
            showLoader()
            NetworkClass.sendRequest(URL: "\(Constants.URLs.trackMembers)\(id)", RequestType: .get, CompletionHandler: {
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

    func processResponse(_ response:AnyObject?) {
        if let arr = response as? NSArray {
            for obj in arr {
                if let dict = obj as? [String: AnyObject] {
                    membersArray.add(UserModel.getUserObject(dict))
                }
            }
        }
        tblVIew.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

    func processError(_ error:NSError?) {
        UIView.showToast("Something went wrong", theme: Theme.error)
    }
}
