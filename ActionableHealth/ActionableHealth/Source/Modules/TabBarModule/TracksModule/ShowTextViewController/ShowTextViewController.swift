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

    //MARK:- Variables
    var text:String?
    var navigationTitle:String?

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text ?? ""
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle(navigationTitle ?? "", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.contentOffset = CGPointZero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
