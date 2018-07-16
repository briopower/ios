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
    var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("Chats", LeftButtonType: BarButtontype.none, RightButtonType: BarButtontype.add)
        messagesListTblView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additional methods
extension ChatsViewController{
    func setupView() {

        _fetchedResultsController = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName("Person", predicate: NSPredicate(format: "messages.@count > 0"), sectionNameKeyPath: nil, sorting: [("lastMessage.timestamp", false)])
        _fetchedResultsController?.delegate = self
        messagesListTblView.rowHeight = UITableViewAutomaticDimension
        messagesListTblView.estimatedRowHeight = 80
        messagesListTblView.register(UINib(nibName: String(describing: MessageListCell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MessageListCell))
        messagesListTblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }

    override func addButtonAction(_ sender:UIButton?){
        super.addButtonAction(sender)

        if let contactList = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.MessagingStoryboard.contactListView) as? ContactListViewController {
            getNavigationController()?.pushViewController(contactList, animated: true)
        }
    }

}

//MARK:- UITableViewDataSource
extension ChatsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = _fetchedResultsController?.fetchedObjects?.count ?? 0
       nullCaseLabel.isHidden = count != 0
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageListCell)) as? MessageListCell, let obj = _fetchedResultsController?.object(at: indexPath) as? Person {
            cell.configureCell(indexPath.row == self.tableView(messagesListTblView, numberOfRowsInSection: indexPath.section) - 1, personObj: obj)
            return cell
        }
        return UITableViewCell()
    }
}
//MARK:- UITableViewDelegate
extension ChatsViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.MessagingStoryboard.messagingView) as? MessagingViewController, let person = _fetchedResultsController?.object(at: indexPath) as? Person {
            DispatchQueue.main.async(execute: {
                viewCont.personObj = person
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }
    }
}

//MARK:- NSFetchedResultsControllerDelegate
extension ChatsViewController:NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        messagesListTblView.reloadData()
    }
}
