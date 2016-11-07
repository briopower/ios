//
//  ChangePasswordViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 04/11/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class ChangePasswordViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var chngPasswordTblView: UITableView!

    //MARK:- Variables
    let submitCell = "ChangePasswordCell_Submit"
    var currnetUser = UserModel()
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("CHANGE PASSWORD", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additional methods
extension ChangePasswordViewController{
    func setupView(){
        chngPasswordTblView.registerNib(UINib(nibName: String(ChangePasswordCell), bundle: nil), forCellReuseIdentifier: String(ChangePasswordCell))
        chngPasswordTblView.registerNib(UINib(nibName: submitCell, bundle: nil), forCellReuseIdentifier: submitCell)

        chngPasswordTblView.estimatedRowHeight = 80
        chngPasswordTblView.rowHeight = UITableViewAutomaticDimension
    }
}

//MARK:- ChangePasswordCellDelegate
extension ChangePasswordViewController:ChangePasswordCellDelegate{
    func submitTapped() {

    }
}
//MARK:- UITableViewDataSource
extension ChangePasswordViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChangePasswordCellType.Count.rawValue
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let type = ChangePasswordCellType(rawValue: indexPath.row) {
            switch type {
            case .Old, .New, .Confirm:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(ChangePasswordCell)) as? ChangePasswordCell{
                    cell.configureCell(type, user: currnetUser)
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCellWithIdentifier(submitCell) as? ChangePasswordCell{
                    cell.delegate = self
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}