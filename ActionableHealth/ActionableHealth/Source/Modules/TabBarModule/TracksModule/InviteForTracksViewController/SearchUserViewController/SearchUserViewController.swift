//
//  SearchUserViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 09/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class SearchUserViewController: CommonViewController {

    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Search User", LeftButtonType: BarButtontype.Cross, RightButtonType: BarButtontype.Done)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- Actions
extension SearchUserViewController{
    override func doneButtonAction(sender: UIButton?) {
        super.doneButtonAction(sender)

    }

    override func crossButtonAction(sender: UIButton?) {
        super.crossButtonAction(sender)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK:- Additonal methods
extension SearchUserViewController{
    func setupView() {
        setNavigationBarBackgroundColor(UIColor.whiteColor())
    }
}
