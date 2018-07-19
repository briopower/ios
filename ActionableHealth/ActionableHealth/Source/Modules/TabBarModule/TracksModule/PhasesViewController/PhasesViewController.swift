//
//  PhasesViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 08/02/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class PhasesViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!

    //MARK:- Variables
    var currentPhase:PhasesModel?
    var sourceType = TrackDetailsSourceType.templates
    let cellName = "TrackPhasesCell_Template"
    let cellNameNoResource = "TrackPhasesCell_NoResources"

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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

//MARK:- Additional methods
extension PhasesViewController{
    func setupView() {
        tblView.register(UINib(nibName: String(describing: TrackPhasesCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TrackPhasesCell.self))
        tblView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        tblView.register(UINib(nibName: cellNameNoResource, bundle: nil), forCellReuseIdentifier: cellNameNoResource)
    }
}

//MARK:- UITableViewDataSource
extension PhasesViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseId = sourceType == .templates ? cellName : "TrackPhasesCell"
        if(currentPhase?.resources.count < 1){
            reuseId = cellNameNoResource
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? TrackPhasesCell, let phase = currentPhase {
            cell.configCell(phase)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDataSource
extension PhasesViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.height() - UIDevice.navigationBarheight()
    }
}
//MARK:- TrackPhasesCellDelegate
extension PhasesViewController:TrackPhasesCellDelegate{
    
    func taskFilesTapped(_ tag: Int, obj: AnyObject?) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.filesListView) as? FilesListViewController {
            viewCont.resources = (obj as? PhasesModel)?.resources ?? NSMutableArray()
            viewCont.navTitle = (obj as? PhasesModel)?.phaseName ?? ""
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }

    func numberOfTasksTapped(_ tag: Int, obj: AnyObject?) {
        if (currentPhase?.tasks.count ?? 0) != 0{
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.taskView) as? TaskListViewController
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


