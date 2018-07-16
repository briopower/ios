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
    var blobKey:String?
    var navigationTitle:String?
    var responseData:Data?
    var httpResponse:HTTPURLResponse?
    var docController:UIDocumentInteractionController?

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle(navigationTitle ?? "", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.details)
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
        if let data = responseData, let mimeType = httpResponse?.mimeType{
            FileManager.save(data, fileName: "response", mimeType: mimeType)
            webView.load(data, mimeType: mimeType, textEncodingName: "utf-8", baseURL: URL())
            webView.delegate = self
        }
    }
}

//MARK:- Action
extension TrackFilesViewController{
    override func detailsButtonAction(_ sender: UIButton?) {
        super.detailsButtonAction(sender)
        if let data = responseData, let mimeType = httpResponse?.mimeType{
            if let path = FileManager.save(data, fileName: (httpResponse?.allHeaderFields["Content-Disposition"] as? String)?.sliceFrom("\"", to: ".") ?? "", mimeType: mimeType){
                let targetURL = URL(fileURLWithPath: path)
                docController = UIDocumentInteractionController(url: targetURL)
                docController?.delegate = self
                docController?.presentOptionsMenu(from: CGRect.zero, in: self.view, animated: true)
            }
        }

    }
}

//MARK:- UIWebViewDelegate
extension TrackFilesViewController:UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideLoader()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.hideLoader()
    }
}
//MARK:- UIDocumentInteractionControllerDelegate
extension TrackFilesViewController:UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController{
        return self
    }

}


//MARK:- Network methods
extension TrackFilesViewController{
    func getFile() {
        if let blobKey = blobKey, NetworkClass.isConnected(true){
            showLoader()
            NetworkClass.sendRequest(URL: "\(Constants.URLs.trackFiles)\(blobKey)/true", RequestType: .GET, ResponseType: .NONE, CompletionHandler: { (status, responseObj, error, statusCode) in
                self.processResponse(responseObj)
            })
        }
    }

    func processResponse(_ responseObj:AnyObject?)  {
        if let arr = responseObj as? NSArray {
            if let urlResponse = arr.firstObject as? HTTPURLResponse {
                httpResponse = urlResponse
            }
            if let data = arr[1] as? Data {
                responseData = data
            }
        }
        loadFileInWebView()
    }
}
