//
//  TrackDetailsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum InfoSectionCellTypes:Int {
    case Details, Members, Files, Count
}
class TrackDetailsViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var trackDetailsTblView: UITableView!
    @IBOutlet var sectionHeaderView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var phaseButton: UIButton!

    //MARK:- Variables
    var currentTemplate:TemplatesModel?
    var isInfoSelected = true
    var sourceType = TrackDetailsSourceType.Home

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateHeader()
        updateTemplate()
        setNavigationBarWithTitle("Details", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)

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
        if NSUserDefaults.isLoggedIn() {
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.commentsView) as? CommentsViewController {
                dispatch_async(dispatch_get_main_queue(), {
                    viewCont.delegate = self
                    viewCont.commentSourceKey = self.currentTemplate?.key
                    self.getNavigationController()?.pushViewController(viewCont, animated: true)
                })
            }
        }else{
            UIViewController.presentLoginViewController()
        }

    }

    func requestButtonTapped(type: TrackDetailsSourceType) {
        if NSUserDefaults.isLoggedIn() {
            switch type {
            case .Home:
                if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.joinTracksView) as? JoinTrackViewController {
                    viewCont.currentTemplate = currentTemplate
                    getNavigationController()?.pushViewController(viewCont, animated: true)
                }
            case .Tracks:
                if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.inviteTracksView) as? InviteForTrackViewController {
                    viewCont.sourceType = .Tracks
                    viewCont.currentTemplate = currentTemplate
                    getNavigationController()?.pushViewController(viewCont, animated: true)
                }
            default:
                break
            }
        }else{
            UIViewController.presentLoginViewController()
        }
    }
}

extension TrackDetailsViewController:CommentsViewControllerDelegate{
    func updatedCommentCount(count: Int) {
        currentTemplate?.commentsCount = count
    }
}
//MARK:- Additional methods
extension TrackDetailsViewController{
    func setupView() {
        infoButtonAction(infoButton)
        if let headerView = TrackDetailsHeaderView.getView() {
            trackDetailsTblView.tableHeaderView = headerView
        }
        updateHeader()

        trackDetailsTblView.rowHeight = UITableViewAutomaticDimension

        trackDetailsTblView.estimatedRowHeight = 200

        trackDetailsTblView.registerNib(UINib(nibName: String(TrackInfoCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackInfoCell))
        trackDetailsTblView.registerNib(UINib(nibName: String(TrackFilesCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackFilesCell))
        trackDetailsTblView.registerNib(UINib(nibName: String(TrackPhasesCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackPhasesCell))

    }

    func updateHeader() {
        if let headerView = trackDetailsTblView.tableHeaderView as? TrackDetailsHeaderView {
            headerView.setupForType(sourceType, template: currentTemplate)
        }
    }
    func setSelectedButton(infoSelected:Bool) {
        infoButton.selected = infoSelected
        phaseButton.selected = !infoSelected
        isInfoSelected = infoSelected
        trackDetailsTblView.reloadData()
    }

    func getInfoCellForIndexPath(indexPath:NSIndexPath) -> UITableViewCell {

        if let type = InfoSectionCellTypes(rawValue: indexPath.row) {
            switch type {
            case .Details:
                if let cell = trackDetailsTblView.dequeueReusableCellWithIdentifier(String(TrackInfoCell)) as? TrackInfoCell {
                    cell.configCell(currentTemplate)
                    return cell
                }
            case .Files, .Members:
                if let cell = trackDetailsTblView.dequeueReusableCellWithIdentifier(String(TrackFilesCell)) as? TrackFilesCell {
                    cell.configCell(type)
                    return cell
                }
            default:
                break
            }
        }
        return UITableViewCell()
    }

    func getPhaseCellForIndexPath(indexPath:NSIndexPath) -> UITableViewCell {
        if let cell = trackDetailsTblView.dequeueReusableCellWithIdentifier(String(TrackPhasesCell)) as? TrackPhasesCell {
            if let phase = currentTemplate?.phases[indexPath.row] as? PhasesModel{
                cell.configCell(phase)
                return cell
            }
        }
        return UITableViewCell()
    }

    func infoCellSelectedAtIndexPath(indexPath:NSIndexPath) {
        if let type = InfoSectionCellTypes(rawValue: indexPath.row) {
            switch type {
            case .Files:
                if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackFileView) as? TrackFilesViewController {
                    viewCont.currentTemplate = currentTemplate
                    getNavigationController()?.pushViewController(viewCont, animated: true)
                }
            case .Members:
                if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackMemberListView) as? TrackMemberListViewController{
                    viewCont.currentTemplate = currentTemplate
                    getNavigationController()?.pushViewController(viewCont, animated: true)
                }
            default:
                break
            }
        }
    }

    func phaseCellSelectedAtIndexPath(indexPath:NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.phaseDetailsView) as? PhaseDetailsViewController {
            viewCont.currentPhase = currentTemplate?.phases[indexPath.row] as? PhasesModel
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }

}

//MARK:- UITableViewDataSource
extension TrackDetailsViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isInfoSelected {
            switch sourceType {
            case .Home:
                return InfoSectionCellTypes.Members.rawValue
            case .Tracks:
                return currentTemplate?.blobKey == nil ?  InfoSectionCellTypes.Files.rawValue : InfoSectionCellTypes.Count.rawValue
            default:
                break
            }
        }
        return currentTemplate?.phases.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if isInfoSelected {
            return getInfoCellForIndexPath(indexPath)
        }else{
            return getPhaseCellForIndexPath(indexPath)
        }
    }
}

//MARK:- UITableViewDelegate
extension TrackDetailsViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isInfoSelected {
            infoCellSelectedAtIndexPath(indexPath)
        }else{
            phaseCellSelectedAtIndexPath(indexPath)
        }
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        return sectionHeaderView
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

//MARK:- Network methods
extension TrackDetailsViewController{
    func updateTemplate() {
        if NetworkClass.isConnected(true) {
            if let id = sourceType == .Home ? currentTemplate?.templateId : currentTemplate?.trackId  {
                let url = sourceType == .Home ? "\(Constants.URLs.templateDetails)\(id)" : "\(Constants.URLs.trackDetails)\(id)"
                NetworkClass.sendRequest(URL: url, RequestType: .GET, CompletionHandler: {
                    (status, responseObj, error, statusCode) in
                    if status{
                        self.processResponse(responseObj)
                    }else{
                        self.processError(error)
                    }
                })
            }
        }
    }

    func processResponse(responseObj:AnyObject?) {
        if let dict = responseObj, let temp = currentTemplate {
            switch sourceType {
            case .Home:
                TemplatesModel.addPhases(dict, toModel: temp)
            case .Tracks:
                TemplatesModel.updateTrackObj(temp, dict: dict)
            default:
                break
            }
            trackDetailsTblView.reloadData()
            updateHeader()
        }
    }
    
    func processError(error:NSError?) {
        
    }
}
