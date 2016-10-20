//
//  TrackFilesViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TrackFilesViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var trackFilesTblView: UITableView!

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("TRACK FILES", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension TrackFilesViewController{
    func setupView() {
        trackFilesTblView.registerNib(UINib(nibName: String(TrackFileCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackFileCell))
        trackFilesTblView.rowHeight = UITableViewAutomaticDimension
        trackFilesTblView.estimatedRowHeight = 100
    }
}

//MARK:- UITableViewDataSource
extension TrackFilesViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier(String(TrackFileCell)) as? TrackFileCell {
            return cell
        }
        return UITableViewCell()
    }
}