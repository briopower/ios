//
//  CommentsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class CommentsViewController: KeyboardAvoidingViewController {

    //MARK:- Outlets
    @IBOutlet weak var commentsTblView: CommonReverseTableView!

    //MARK:- Variables
    var shouldScrollToBottom = true

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldScrollToBottom {
            moveToBottom()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if shouldScrollToBottom {
            moveToBottom()
            shouldScrollToBottom = false
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Comments", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additonal methods
extension CommentsViewController{
    func setupView() {
        commentsTblView.tableViewType = ReverseTableViewType.Comments
        commentsTblView.estimatedRowHeight = 100
        commentsTblView.dataArray = ["", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", "","", "", ""]
        commentsTblView.reverseTableViewDelegate = self
    }

    override func moveToBottom() {
        if (commentsTblView.contentSize.height > commentsTblView.frame.size.height){
            let point = CGPoint(x: 0, y: commentsTblView.contentSize.height - commentsTblView.frame.size.height)
            commentsTblView.contentOffset = point
        }
    }
}

//MARK:- ReverseTableViewDelegate
extension CommentsViewController:ReverseTableViewDelegate{
    func topElements(view: UIView) {
        print("Get Top Elemets")
    }

    func clickedAtIndexPath(indexPath: NSIndexPath, obj: AnyObject) {
        
    }
}