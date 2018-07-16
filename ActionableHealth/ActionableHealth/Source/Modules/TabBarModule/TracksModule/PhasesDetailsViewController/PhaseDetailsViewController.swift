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
    var currentTask:TasksModel?


    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phaseDetailsTblView.reloadData()
        if let title = currentPhase?.phaseName {
            setNavigationBarWithTitle(title, LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        }
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
    @IBAction func rateTaskAction(_ sender: UIButton) {
        submitRating()
    }
    @IBAction func hideRatingActtion(_ sender: AnyObject) {
        hideRatingView()
    }
}

//MARK:- Additional methods
extension PhaseDetailsViewController{
    func setupView(){

        //        if let headerView = AllTaskCompletedHeaderView.getView() {
        //            phaseDetailsTblView.tableHeaderView = headerView
        //        }

        phaseDetailsTblView.rowHeight = UIScreen.main.bounds.height - 44
//        phaseDetailsTblView.estimatedRowHeight = 400
        phaseDetailsTblView.register(UINib(nibName: String(describing: PhaseDetailsCell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: PhaseDetailsCell))
        phaseDetailsTblView.register(UINib(nibName: PhaseDetailsCell.statusCell, bundle: Bundle.main), forCellReuseIdentifier: PhaseDetailsCell.statusCell)
        phaseDetailsTblView.register(UINib(nibName: PhaseDetailsCell.completedCell, bundle: Bundle.main), forCellReuseIdentifier: PhaseDetailsCell.completedCell)
        phaseDetailsTblView.register(UINib(nibName: PhaseDetailsCell.informationCell, bundle: Bundle.main), forCellReuseIdentifier: PhaseDetailsCell.informationCell)
        
        
        phaseDetailsTblView.register(UINib(nibName: PhaseDetailsCell.completedNoResourceCell, bundle: Bundle.main), forCellReuseIdentifier: PhaseDetailsCell.completedNoResourceCell)
        phaseDetailsTblView.register(UINib(nibName: PhaseDetailsCell.statusNoResourceCell, bundle: Bundle.main), forCellReuseIdentifier: PhaseDetailsCell.statusNoResourceCell)

    }
}

//MARK:- UITableViewDataSource
extension PhaseDetailsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let type = currentPhase?.parentTemplate.objectType {
            switch type {
                //changed cell from pohasedetailscell to phasedetailcell.
            case .template:
                var identifier : String!
                if let task = currentTask {
                    identifier = task.resources.count > 0 ? String(describing: PhaseDetailsCell) : String(PhaseDetailsCell.informationCell)
                }

                if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PhaseDetailsCell {
                    if let task = currentTask {
                        cell.tag = indexPath.row
                        cell.delegate = self
                        cell.configureCell(task)
                        return cell
                    }
                }
            case .track:
                if let task = currentTask {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: TaskStatus.getNibName(task)) as? PhaseDetailsCell {
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
    func updatedCommentCount(_ count: Int) {
        selectedTask?.commentsCount = count
    }
}

//MARK:- RatingView Methods / PhaseDetailsCellDelegate
extension PhaseDetailsViewController:PhaseDetailsCellDelegate{
    func commentsTapped(_ tag: Int, obj: AnyObject?) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.commentsView) as? CommentsViewController, let commentSourceKey = obj as? String {
            DispatchQueue.main.async(execute: {
                if let task = self.currentPhase?.tasks[tag] as? TasksModel {
                    self.selectedTask = task
                }
                viewCont.delegate = self
                viewCont.commentSourceKey = commentSourceKey + "_\(UserDefaults.getUserId())"
                viewCont.titleString = "Journal(s)"
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }

    }
    
    func taskFilesTapped(_ tag: Int, obj: AnyObject?) {

        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.filesListView) as? FilesListViewController {
            viewCont.resources = (obj as? TasksModel)?.resources ?? NSMutableArray()
            viewCont.navTitle = currentPhase?.phaseName ?? ""
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }

    func rateTaskTapped(_ tag: Int, obj: AnyObject?) {
        if let task = obj as? TasksModel {
            showRatingView(task)
        }
    }

    func showRatingView(_ task:TasksModel) {
        if let view = getNavigationController()?.view {
            ratingView.alpha = 0
            ratingView.frame = view.frame
            ratingView.isUserInteractionEnabled = false
            starRatingView.value = CGFloat(task.rating)
            view.addSubview(ratingView)
            selectedTask = task
            UIView.animate(withDuration: 0.3, animations: {
                self.ratingView.alpha = 1
                }, completion: { (completed:Bool) in
                    self.ratingView.isUserInteractionEnabled = true
            })
        }
    }

    func hideRatingView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.ratingView.alpha = 0
            self.ratingView.isUserInteractionEnabled = false
        }, completion: { (completed:Bool) in
            self.ratingView.isUserInteractionEnabled = false
        }) 
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

    func processResponse(_ response:AnyObject?) {
        selectedTask?.updateRating(response)
        phaseDetailsTblView.reloadData()
        hideRatingView()
    }
}

