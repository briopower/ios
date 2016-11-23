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

    //MARK:- Variables
    var currentTemplate:TemplatesModel?
    
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
        getFiles()
    }
}

//MARK:- UITableViewDataSource
extension TrackFilesViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier(String(TrackFileCell)) as? TrackFileCell {
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- Network methods
extension TrackFilesViewController{
    func getFiles() {

        if let blobKey = currentTemplate?.blobKey where NetworkClass.isConnected(true){
            showLoader()
            NetworkClass.sendRequest(URL: "\(Constants.URLs.trackFiles)\(blobKey)", RequestType: .GET, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if status{
                    self.processResponse(responseObj)
                }else{
                    self.processError(error)
                }
                self.hideLoader()
            })
        }
    }

    func processResponse(responseObj:AnyObject?) {
        if let dict = responseObj where currentTemplate != nil {
            print(dict)
        }
    }

    func processError(error:NSError?) {

    }
}