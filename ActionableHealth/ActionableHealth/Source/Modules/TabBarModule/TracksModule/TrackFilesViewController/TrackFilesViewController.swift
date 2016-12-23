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
    var responseData:NSData?
    var httpResponse:NSHTTPURLResponse?
    var docController:UIDocumentInteractionController?

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Track Files", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.Details)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension TrackFilesViewController{
    func setupView() {
        getFile()
    }

    func loadFileInWebView() {
        if let data = responseData, let mimeType = httpResponse?.MIMEType{
            webView.loadData(data, MIMEType: mimeType, textEncodingName: "utf-8", baseURL: NSURL())
        }
    }
}

//MARK:- Action
extension TrackFilesViewController{
    override func detailsButtonAction(sender: UIButton?) {
        super.detailsButtonAction(sender)
        if let data = responseData, let mimeType = httpResponse?.MIMEType{
            if let path = NSFileManager.save(data, fileName: (httpResponse?.allHeaderFields["Content-Disposition"] as? String)?.sliceFrom("\"", to: ".") ?? "", mimeType: mimeType){
                let targetURL = NSURL(fileURLWithPath: path)
                docController = UIDocumentInteractionController(URL: targetURL)
                docController?.delegate = self
                docController?.presentOptionsMenuFromRect(CGRect.zero, inView: self.view, animated: true)
            }
        }

    }
}

//MARK:- UIDocumentInteractionControllerDelegate
extension TrackFilesViewController:UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController{
        return self
    }

}


//MARK:- Network methods
extension TrackFilesViewController{
    func getFile() {
        if let blobKey = currentTemplate?.blobKey where NetworkClass.isConnected(true){
            showLoader()
            NetworkClass.sendRequest(URL: "\(Constants.URLs.trackFiles)\(blobKey)/true", RequestType: .GET, ResponseType: .NONE, CompletionHandler: { (status, responseObj, error, statusCode) in
                self.processResponse(responseObj)
                self.hideLoader()
            })
        }
    }

    func processResponse(responseObj:AnyObject?)  {
        if let arr = responseObj as? NSArray {
            if let urlResponse = arr.firstObject as? NSHTTPURLResponse {
                httpResponse = urlResponse
            }

            if let data = arr[1] as? NSData {
                responseData = data
            }
        }
        loadFileInWebView()
    }
}
