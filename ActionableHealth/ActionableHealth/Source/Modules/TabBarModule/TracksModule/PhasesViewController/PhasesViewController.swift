//
//  PhasesViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 08/02/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

class PhasesViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!

    //MARK:- Variables
    var currentPhase:PhasesModel?
    var sourceType = TrackDetailsSourceType.Templates
    let cellName = "TrackPhasesCell_Template"
    let cellNameNoResource = "TrackPhasesCell_NoResources"

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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

//MARK:- Additional methods
extension PhasesViewController{
    func setupView() {
        tblView.registerNib(UINib(nibName: String(TrackPhasesCell), bundle: nil), forCellReuseIdentifier: String(TrackPhasesCell))
        tblView.registerNib(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        tblView.registerNib(UINib(nibName: cellNameNoResource, bundle: nil), forCellReuseIdentifier: cellNameNoResource)
    }
}

//MARK:- UITableViewDataSource
extension PhasesViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseId = sourceType == .Templates ? cellName : String(TrackPhasesCell)
        if(currentPhase?.resources.count < 1){
            reuseId = cellNameNoResource
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier(reuseId) as? TrackPhasesCell, let phase = currentPhase {
            cell.configCell(phase)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDataSource
extension PhasesViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIDevice.height() - UIDevice.navigationBarheight()
    }
}
//MARK:- TrackPhasesCellDelegate
extension PhasesViewController:TrackPhasesCellDelegate{
    
    func taskFilesTapped(tag: Int, obj: AnyObject?) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.filesListView) as? FilesListViewController {
            viewCont.resources = (obj as? PhasesModel)?.resources ?? NSMutableArray()
            viewCont.navTitle = (obj as? PhasesModel)?.phaseName ?? ""
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }

    func numberOfTasksTapped(tag: Int, obj: AnyObject?) {
        if (currentPhase?.tasks.count ?? 0) != 0{
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.taskView) as? TaskListViewController
            {
                viewCont.currentPhase = currentPhase
                getNavigationController()?.pushViewController(viewCont, animated: true)
            }
//            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.phaseDetailsView) as? PhaseDetailsViewController {
//                viewCont.currentPhase = currentPhase
//                getNavigationController()?.pushViewController(viewCont, animated: true)
//            }
        }
    }
}


