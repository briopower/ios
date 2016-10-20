//
//  TrackDetailsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TrackDetailsViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var trackDetailsTblView: UITableView!
    @IBOutlet var sectionHeaderView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var phaseButton: UIButton!

    //MARK:- Variables
    var isInfoSelected = true
    var sourceType = TrackDetailsSourceType.Home

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("TRACK DETAILS", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = trackDetailsTblView.tableHeaderView as? TrackDetailsHeaderView {
            headerView.delegate = self
            headerView.setupFrame()
            trackDetailsTblView.tableHeaderView = headerView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//MARK:- Button Actions
extension TrackDetailsViewController{
    @IBAction func infoButtonAction(sender: UIButton) {
        setSelectedButton(true)
    }
    @IBAction func sectionButtonActions(sender: UIButton) {
        setSelectedButton(false)
    }

}
//MARK:- TrackDetailsHeaderViewDelegate
extension TrackDetailsViewController:TrackDetailsHeaderViewDelegate{
    func commentsTapped(type: TrackDetailsSourceType) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.commentsView) as? CommentsViewController {
            self.navigationController?.pushViewController(viewCont, animated: true)
        }
    }

    func requestButtonTapped(type: TrackDetailsSourceType) {
        switch type {
        case .Home:
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.joinTracksView) as? JoinTrackViewController {
                self.navigationController?.pushViewController(viewCont, animated: true)
            }
        case .Tracks:
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.inviteTracksView) as? InviteForTrackViewController {
                self.navigationController?.pushViewController(viewCont, animated: true)
            }
        default:
            break
        }
    }
}
//MARK:- Additional methods
extension TrackDetailsViewController{
    func setupView() {
        infoButtonAction(infoButton)
        if let headerView = TrackDetailsHeaderView.getView() {
            headerView.setupForType(sourceType)
            trackDetailsTblView.tableHeaderView = headerView
        }

        trackDetailsTblView.rowHeight = UITableViewAutomaticDimension
        trackDetailsTblView.estimatedRowHeight = 80

        trackDetailsTblView.registerNib(UINib(nibName: String(TrackInfoCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackInfoCell))
        trackDetailsTblView.registerNib(UINib(nibName: String(TrackFilesCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackFilesCell))
        trackDetailsTblView.registerNib(UINib(nibName: String(TrackPhasesCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackPhasesCell))

    }

    func setSelectedButton(infoSelected:Bool) {
        infoButton.selected = infoSelected
        phaseButton.selected = !infoSelected
        isInfoSelected = infoSelected
        trackDetailsTblView.reloadData()
    }

    func getInfoCellForIndexPath(indexPath:NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            if let cell = trackDetailsTblView.dequeueReusableCellWithIdentifier(String(TrackInfoCell)) as? TrackInfoCell {
                return cell
            }
        }else{
            if let cell = trackDetailsTblView.dequeueReusableCellWithIdentifier(String(TrackFilesCell)) as? TrackFilesCell {
                return cell
            }
        }
        return UITableViewCell()
    }

    func getPhaseCellForIndexPath(indexPath:NSIndexPath) -> UITableViewCell {
        if let cell = trackDetailsTblView.dequeueReusableCellWithIdentifier(String(TrackPhasesCell)) as? TrackPhasesCell {
            return cell
        }
        return UITableViewCell()
    }

    func infoCellSelectedAtIndexPath(indexPath:NSIndexPath) {
        if indexPath.row == 1{
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackFileView) as? TrackFilesViewController {
                self.navigationController?.pushViewController(viewCont, animated: true)
            }
        }
    }

    func phaseCellSelectedAtIndexPath(indexPath:NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.phaseDetailsView) as? PhaseDetailsViewController {
            self.navigationController?.pushViewController(viewCont, animated: true)
        }
    }

}

//MARK:- UITableViewDataSource
extension TrackDetailsViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isInfoSelected {
            return 2
        }
        return 50
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if isInfoSelected {
            return getInfoCellForIndexPath(indexPath)
        }
        return getPhaseCellForIndexPath(indexPath)
    }
}

//MARK:- UITableViewDelegate
extension TrackDetailsViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isInfoSelected {
            infoCellSelectedAtIndexPath(indexPath)
        }
        phaseCellSelectedAtIndexPath(indexPath)
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        return sectionHeaderView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}