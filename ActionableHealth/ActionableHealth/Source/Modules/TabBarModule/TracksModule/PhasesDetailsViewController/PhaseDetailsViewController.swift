//
//  PhaseDetailsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class PhaseDetailsViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var phaseDetailsTblView: UITableView!
    @IBOutlet var ratingView: UIView!
    @IBOutlet weak var starRatingView: HCSStarRatingView!

    //MARK:- Varibales
    var currentPhase:PhasesModel?
    var selectedTask:TasksModel?

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        phaseDetailsTblView.reloadData()
        setNavigationBarWithTitle(currentPhase?.phaseName ?? "", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = phaseDetailsTblView.tableHeaderView as? AllTaskCompletedHeaderView {
            headerView.setupFrame()
            phaseDetailsTblView.tableHeaderView = headerView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

//MARK:- Button Actions
extension PhaseDetailsViewController{
    @IBAction func rateTaskAction(sender: UIButton) {
        submitRating()
    }
    @IBAction func hideRatingActtion(sender: AnyObject) {
        hideRatingView()
    }
}

//MARK:- Additional methods
extension PhaseDetailsViewController{
    func setupView(){

        //        if let headerView = AllTaskCompletedHeaderView.getView() {
        //            phaseDetailsTblView.tableHeaderView = headerView
        //        }

        phaseDetailsTblView.rowHeight = UITableViewAutomaticDimension
        phaseDetailsTblView.estimatedRowHeight = 400
        phaseDetailsTblView.registerNib(UINib(nibName: String(PhaseDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(PhaseDetailsCell))
        phaseDetailsTblView.registerNib(UINib(nibName: PhaseDetailsCell.statusCell, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: PhaseDetailsCell.statusCell)
        phaseDetailsTblView.registerNib(UINib(nibName: PhaseDetailsCell.completedCell, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: PhaseDetailsCell.completedCell)
        phaseDetailsTblView.registerNib(UINib(nibName: PhaseDetailsCell.informationCell, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: PhaseDetailsCell.informationCell)

    }
}

//MARK:- UITableViewDataSource
extension PhaseDetailsViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPhase?.tasks.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let type = currentPhase?.parentTemplate.objectType {
            switch type {
                //changed cell from pohasedetailscell to phasedetailcell.
            case .Template:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(PhaseDetailsCell.informationCell)) as? PhaseDetailsCell {
                    if let task = currentPhase?.tasks[indexPath.row] as? TasksModel {
                        cell.tag = indexPath.row
                        cell.delegate = self
                        cell.configureCell(task)
                        return cell
                    }
                }
            case .Track:
                if let task = currentPhase?.tasks[indexPath.row] as? TasksModel {
                    if let cell = tableView.dequeueReusableCellWithIdentifier(TaskStatus.getNibName(task.status)) as? PhaseDetailsCell {
                        cell.tag = indexPath.row
                        cell.delegate = self
                        cell.configureCell(task)
                        return cell
                    }
                }
            default:
                break
            }
        }
        return UITableViewCell()
    }
}

//MARK:- CommentsViewControllerDelegate
extension PhaseDetailsViewController:CommentsViewControllerDelegate{
    func updatedCommentCount(count: Int) {
        selectedTask?.commentsCount = count
    }
}

//MARK:- RatingView Methods / PhaseDetailsCellDelegate
extension PhaseDetailsViewController:PhaseDetailsCellDelegate{
    func commentsTapped(tag: Int, obj: AnyObject?) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.commentsView) as? CommentsViewController, let commentSourceKey = obj as? String {
            dispatch_async(dispatch_get_main_queue(), {
                if let task = self.currentPhase?.tasks[tag] as? TasksModel {
                    self.selectedTask = task
                }
                viewCont.delegate = self
                viewCont.commentSourceKey = commentSourceKey + "_\(NSUserDefaults.getUserId())"
                viewCont.titleString = "Journal(s)"
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }

    }
    
    func taskFilesTapped(tag: Int, obj: AnyObject?) {

        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.filesListView) as? FilesListViewController {
            viewCont.resources = (obj as? TasksModel)?.resources ?? NSMutableArray()
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }

    func rateTaskTapped(tag: Int, obj: AnyObject?) {
        if let task = obj as? TasksModel {
            showRatingView(task)
        }
    }

    func showRatingView(task:TasksModel) {
        if let view = getNavigationController()?.view {
            ratingView.alpha = 0
            ratingView.frame = view.frame
            ratingView.userInteractionEnabled = false
            starRatingView.value = CGFloat(task.rating)
            view.addSubview(ratingView)
            selectedTask = task
            UIView.animateWithDuration(0.3, animations: {
                self.ratingView.alpha = 1
                }, completion: { (completed:Bool) in
                    self.ratingView.userInteractionEnabled = true
            })
        }
    }

    func hideRatingView() {
        UIView.animateWithDuration(0.3, animations: {
            self.ratingView.alpha = 0
            self.ratingView.userInteractionEnabled = false
        }) { (completed:Bool) in
            self.ratingView.userInteractionEnabled = false
        }
    }
}

//MARK:- NetworkMethodse
extension PhaseDetailsViewController{
    func submitRating() {
        if NetworkClass.isConnected(true), let key = selectedTask?.key.getValidObject(){
            showLoaderOnWindow()
            NetworkClass.sendRequest(URL: Constants.URLs.rating, RequestType: .POST, Parameters: TasksModel.getDictForRating(key, rating: starRatingView.value), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if statusCode == 200{
                    self.processResponse(responseObj)
                }
                self.hideLoader()
            })
        }
    }

    func processResponse(response:AnyObject?) {
        selectedTask?.updateRating(response)
        phaseDetailsTblView.reloadData()
        hideRatingView()
    }
}

