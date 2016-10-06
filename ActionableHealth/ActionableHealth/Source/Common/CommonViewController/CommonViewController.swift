//
//  CommonViewController.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {
    //MARK:- variables
    var nullCaseView:NullCaseView?
    var showLoading = true
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.dissmissKeyboard()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.dissmissKeyboard()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    //MARK: Nullcase Delegate
    func retryButtonTapped(nullCaseType: NullCaseType, identifier: Int?) {

    }
}




