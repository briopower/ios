//
//  TaskListViewController.swift
//  ActionableHealth
//
//  Created by Abhishek Sharma on 31/05/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

class TaskListViewController: CommonViewController  {
    var currentPhase:PhasesModel?
    
    @IBOutlet var taskListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let title = currentPhase?.phaseName {
            setNavigationBarWithTitle(title, LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TaskListViewController{
    func setUpView(){
        taskListTableView.estimatedRowHeight = 200
        taskListTableView.rowHeight = UITableViewAutomaticDimension
        taskListTableView.registerNib(UINib(nibName: String(TrackFilesCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackFilesCell))
        taskListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
}


extension TaskListViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPhase?.tasks.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = taskListTableView.dequeueReusableCellWithIdentifier(String(TrackFilesCell)) as? TrackFilesCell {
            if let task = currentPhase?.tasks[indexPath.row] as? TasksModel{
                cell.configTaskCell(task)
            }
           return cell
        }
        return UITableViewCell()
    }
    
}

extension TaskListViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.phaseDetailsView) as? PhaseDetailsViewController {
            viewCont.currentPhase = currentPhase
            if let task = currentPhase?.tasks[indexPath.row] as? TasksModel{
                viewCont.currentTask = task
            }
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }

    }
}

