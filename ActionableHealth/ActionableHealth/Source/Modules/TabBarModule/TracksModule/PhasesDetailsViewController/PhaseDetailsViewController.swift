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

    //MARK:- Varibales
    var currentPhase:PhasesModel?

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        phaseDetailsTblView.estimatedRowHeight = 100
        phaseDetailsTblView.registerNib(UINib(nibName: String(PhaseDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(PhaseDetailsCell))
        phaseDetailsTblView.registerNib(UINib(nibName: PhaseDetailsCell.statusCell, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: PhaseDetailsCell.statusCell)
    }
}

//MARK:- UITableViewDataSource
extension PhaseDetailsViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPhase?.tasks.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier(String(PhaseDetailsCell)) as? PhaseDetailsCell {
            if let task = currentPhase?.tasks[indexPath.row] as? TasksModel {
                cell.tag = indexPath.row
                cell.delegate = self
                cell.configureCell(task)
                return cell
            }
        }

        return UITableViewCell()
    }
}

//MARK:- RatingView Methods
extension PhaseDetailsViewController:PhaseDetailsCellDelegate{
    func commentsTapped(tag: Int, obj: AnyObject?) {
        if NSUserDefaults.isLoggedIn() {
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.commentsView) as? CommentsViewController {
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController?.pushViewController(viewCont, animated: true)
                })
            }
        }else{
            UIViewController.presentLoginViewController()
        }
    }

    func rateTaskTapped(tag: Int, obj: AnyObject?) {
        if NSUserDefaults.isLoggedIn() {
            showRatingView()
        }else{
            UIViewController.presentLoginViewController()
        }
    }

    func showRatingView() {
        if let view = getNavigationController()?.view {
            ratingView.alpha = 0
            ratingView.frame = view.frame
            ratingView.userInteractionEnabled = false
            view.addSubview(ratingView)
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
