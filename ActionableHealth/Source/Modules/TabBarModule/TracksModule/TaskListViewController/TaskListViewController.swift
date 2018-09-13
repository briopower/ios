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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let title = currentPhase?.phaseName {
            setNavigationBarWithTitle(title, LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
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
        taskListTableView.register(UINib(nibName: String(describing: TrackFilesCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: TrackFilesCell.self))
        taskListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
}


extension TaskListViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPhase?.tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = taskListTableView.dequeueReusableCell(withIdentifier: String(describing: TrackFilesCell.self)) as? TrackFilesCell {
            if let task = currentPhase?.tasks[indexPath.row] as? TasksModel{
                cell.configTaskCell(task)
            }
           return cell
        }
        return UITableViewCell()
    }
    
}

extension TaskListViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.phaseDetailsView) as? PhaseDetailsViewController {
            viewCont.currentPhase = currentPhase
            if let task = currentPhase?.tasks[indexPath.row] as? TasksModel{
                viewCont.currentTask = task
            }
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }

    }
}

