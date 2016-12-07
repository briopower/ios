//
//  SearchUserViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 09/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class SearchUserViewController: CommonViewController {

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//MARK:- Additonal methods
extension SearchUserViewController{
    func setupView() {
        setNavigationBarBackgroundColor(UIColor.whiteColor())
    }
}
