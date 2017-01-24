//
//  ChatsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 07/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
import CoreData

class ChatsViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var messagesListTblView: UITableView!
    @IBOutlet weak var nullCaseLabel: UILabel!

    //MARK:- Variables
    var _fetchedResultsController: NSFetchedResultsController?

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("Chats", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.None)
        messagesListTblView.reloadData()
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

        _fetchedResultsController = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName(String(Person), predicate: NSPredicate(format: "messages.@count > 0"), sectionNameKeyPath: nil, sorting: [("lastMessage.timestamp", false)])
        _fetchedResultsController?.delegate = self
        messagesListTblView.rowHeight = UITableViewAutomaticDimension
        messagesListTblView.estimatedRowHeight = 80
        messagesListTblView.registerNib(UINib(nibName: String(MessageListCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(MessageListCell))
        messagesListTblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
}

//MARK:- UITableViewDataSource
extension ChatsViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = _fetchedResultsController?.fetchedObjects?.count ?? 0
       nullCaseLabel.hidden = count != 0
        return count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(MessageListCell)) as? MessageListCell, let obj = _fetchedResultsController?.objectAtIndexPath(indexPath) as? Person {
            cell.configureCell(indexPath.row == self.tableView(messagesListTblView, numberOfRowsInSection: indexPath.section) - 1, personObj: obj)
            return cell
        }
        return UITableViewCell()
    }
}
//MARK:- UITableViewDelegate
extension ChatsViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.MessagingStoryboard.messagingView) as? MessagingViewController, let person = _fetchedResultsController?.objectAtIndexPath(indexPath) as? Person {
            dispatch_async(dispatch_get_main_queue(), {
                viewCont.personObj = person
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }
    }
}

//MARK:- NSFetchedResultsControllerDelegate
extension ChatsViewController:NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        messagesListTblView.reloadData()
    }
}
