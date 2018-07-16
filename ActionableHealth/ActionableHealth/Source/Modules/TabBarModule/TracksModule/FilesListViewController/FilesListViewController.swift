//
//  FilesListViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/02/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

class FilesListViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var nullCaseLabel: UILabel!

    //MARK:- Variables
    var resources = NSMutableArray()
    var navTitle = ""

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle(navTitle, LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additional Methods
extension FilesListViewController{
    func setupView(){
        tblView.register(UINib(nibName: String(describing: FilesCell), bundle: nil), forCellReuseIdentifier: String(describing: FilesCell))
        tblView.estimatedRowHeight = 80
        tblView.rowHeight = UITableViewAutomaticDimension
    }
}

//MARK:- UITableViewDataSource
extension FilesListViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfCell = resources.count
        if numberOfCell == 0 {
            UIView.showToast("No Files Found.", theme: Theme.warning)
            nullCaseLabel.isHidden = false
        }else{
            nullCaseLabel.isHidden = true
        }
        return numberOfCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilesCell)) as? FilesCell, let resourceObj = resources[indexPath.row] as? Resources{
            cell.configCell(resourceObj)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension FilesListViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.trackFileView) as? TrackFilesViewController,let resourceObj = resources[indexPath.row] as? Resources {
            viewCont.blobKey = resourceObj.blobKey
            viewCont.navigationTitle = resourceObj.fileName
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}
