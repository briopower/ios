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
    @IBOutlet weak var webView: UIWebView!

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
        loadFileInWebView()
    }
}

//MARK:- Network methods
extension TrackFilesViewController{
    func loadFileInWebView() {
        if let blobKey = currentTemplate?.blobKey where NetworkClass.isConnected(true){
            if let url = NSURL(string: "\(Constants.URLs.trackFiles)\(blobKey)/true")  {
                let request = NSMutableURLRequest(URL:url)
                let headers = NetworkClass.getUpdatedHeader(nil)
                for (key,value) in headers {
                    print(key)
                    print(value)
                    request.setValue(value, forHTTPHeaderField: key)
                }
                webView.loadRequest(request)
            }
        }
    }
}