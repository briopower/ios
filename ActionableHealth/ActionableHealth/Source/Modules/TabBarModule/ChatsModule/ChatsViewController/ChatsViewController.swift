//
//  ChatsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 07/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class ChatsViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var messagesListTblView: UITableView!

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("Chats", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.None)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additional methods
extension ChatsViewController{
    func  setupView() {
        messagesListTblView.rowHeight = UITableViewAutomaticDimension
        messagesListTblView.estimatedRowHeight = 80
        messagesListTblView.registerNib(UINib(nibName: String(MessageListCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(MessageListCell))
        messagesListTblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
}

//MARK:- UITableViewDataSource
extension ChatsViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(MessageListCell)) as? MessageListCell {
            cell.configureCell(indexPath.row == self.tableView(messagesListTblView, numberOfRowsInSection: indexPath.section) - 1)
            return cell
        }
        return UITableViewCell()
    }
}
//MARK:- UITableViewDelegate
extension ChatsViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.MessagingStoryboard.messagingView) as? MessagingViewController {
            dispatch_async(dispatch_get_main_queue(), { 
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }
    }
}
