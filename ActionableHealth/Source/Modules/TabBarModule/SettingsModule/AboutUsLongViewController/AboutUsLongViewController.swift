//
//  AboutUsLongViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/01/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

class AboutUsLongViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var txtView: UITextView!

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("About Us", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        txtView.contentOffset = CGPoint.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
