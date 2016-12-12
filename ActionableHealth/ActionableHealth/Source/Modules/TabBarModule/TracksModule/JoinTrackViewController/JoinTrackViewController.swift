//
//  JoinTrackViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class JoinTrackViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!

    //MARK:- Variables
    var currentTemplate:TemplatesModel?

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Join Track", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//MARK:- Additional methods
extension JoinTrackViewController{
    func setupView() {
        tblView.registerNib(UINib(nibName: String(InviteForTrackCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(InviteForTrackCell))
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 80
    }

    func createYourOwn() {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.inviteTracksView) as? InviteForTrackViewController {
            viewCont.sourceType = .Home
            viewCont.currentTemplate = currentTemplate
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }

    func requestAdmin(){

    }
}

//MARK:- UITableViewDataSource
extension JoinTrackViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let type = InviteForTrackCellType(rawValue: indexPath.row) {
            switch type {
            case .RequestAdmin, .CreateYourOwn:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(InviteForTrackCell)) as? InviteForTrackCell {
                    cell.configCell(type, template:currentTemplate)
                    cell.delegate = self
                    return cell
                }
            default:
                break
            }
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension JoinTrackViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

//MARK:- InviteForTrackCellDelegate
extension JoinTrackViewController:InviteForTrackCellDelegate{
    func actionButtonClicked(type: InviteForTrackCellType) {
        switch type {
        case .CreateYourOwn:
            createYourOwn()
        case .RequestAdmin:
            requestAdmin()
        default:
            break
        }
    }
}
