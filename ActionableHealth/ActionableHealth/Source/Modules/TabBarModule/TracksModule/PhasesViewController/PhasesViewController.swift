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
    var currentTemplate:TemplatesModel?
    var sourceType = TrackDetailsSourceType.Templates

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateTemplate()
        setNavigationBarWithTitle("Phases", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
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
        tblView.estimatedRowHeight = 300
        tblView.rowHeight = UITableViewAutomaticDimension
    }

}

//MARK:- UITableViewDataSource
extension PhasesViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTemplate?.phases.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(TrackPhasesCell)) as? TrackPhasesCell, let phase = currentTemplate?.phases[indexPath.row] as? PhasesModel {
            cell.configCell(phase)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension PhasesViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.phaseDetailsView) as? PhaseDetailsViewController {
            viewCont.currentPhase = currentTemplate?.phases[indexPath.row] as? PhasesModel
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}

//MARK:- TrackPhasesCellDelegate
extension PhasesViewController:TrackPhasesCellDelegate{
    func readMoreTapped(tag: Int, obj: AnyObject?) {
        if let task = obj as? PhasesModel {
            if let showTextView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.showTextView) as? ShowTextViewController {
                showTextView.text = task.details
                showTextView.navigationTitle = task.phaseName
                getNavigationController()?.pushViewController(showTextView, animated: true)
            }
        }
    }

    func taskFilesTapped(tag: Int, obj: AnyObject?) {

        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.filesListView) as? FilesListViewController {
            viewCont.resources = (obj as? PhasesModel)?.resources ?? NSMutableArray()
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}

//MARK:- Network methods
extension PhasesViewController{

    func updateTemplate() {
        if NetworkClass.isConnected(true) {
            if let id = sourceType == .Templates ? currentTemplate?.templateId : currentTemplate?.trackId  {
                let url = sourceType == .Templates ? "\(Constants.URLs.templateDetails)\(id)" : "\(Constants.URLs.trackDetails)\(id)"
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
            case .Templates:
                TemplatesModel.addPhases(dict, toModel: temp)
            case .Tracks:
                TemplatesModel.updateTrackObj(temp, dict: dict)
            default:
                break
            }
        }
        tblView.reloadData()
    }

    func processError(error:NSError?) {
        UIView.showToast(error?.localizedDescription ?? "", theme: Theme.Error)
    }
}
