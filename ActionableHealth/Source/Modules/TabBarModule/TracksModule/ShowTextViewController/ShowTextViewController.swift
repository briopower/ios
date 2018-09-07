//
//  ShowTextViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 25/01/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

class ShowTextViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var webView: UIWebView!

    //MARK:- Variables
    var text:String?
    var html:String?
    var navigationTitle:String?

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = text {
            textView.text = text
            textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }else{
            textView.isHidden = true
        }

        if let html = html {
            webView.loadHTMLString(html, baseURL: nil)
        }else{
            webView.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle(navigationTitle ?? "", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.contentOffset = CGPoint.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
