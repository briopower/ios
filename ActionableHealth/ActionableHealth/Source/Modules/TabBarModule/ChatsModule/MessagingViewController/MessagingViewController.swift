//
//  MessagingViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
import CoreData

class MessagingViewController: JSQMessagesViewController {

    //MARK:- Variables
    var _fetchedResultsController: NSFetchedResultsController?
    var personObj:Person?
    var trackName:String?

    let outgoingBubbleImageView = JSQMessagesBubbleImage(messageBubbleImage: UIImage(named:"sentMessage")!, highlightedImage: UIImage(named:"sentMessage")!)
    let incomingBubbleImageView = JSQMessagesBubbleImage(messageBubbleImage: UIImage(named:"recievedMessage")!, highlightedImage: UIImage(named:"recievedMessage")!)
    let dummAvtarIcon = JSQMessagesAvatarImage(placeholder: UIImage(named:"circle-user-ic")!)
    var shouldScroll = true

    //MARK:- Outlets
    @IBOutlet var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var text = Contact.getNameForContact(personObj?.personId ?? "") ?? personObj?.personId ?? ""
        if let lastTrackName = trackName ?? personObj?.lastTrack {
            text += " (\(lastTrackName))"
        }
        titleLabel.text = text
        titleLabel.sizeToFit()
        titleView.frame = CGRect(origin: CGPointZero, size: titleLabel.frame.size)
        setNavigationBarWithTitleView(titleView, LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        personObj?.markAllAsRead()
        AppDelegate.getAppDelegateObject()?.saveContext()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        uponDidAppear()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        MessagingManager.sharedInstance.chattingWithPerson = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        collectionView?.removeObserver(self, forKeyPath: "contentSize")
    }

}

//MARK:- Additional methods
extension MessagingViewController{
    func setupView() {
        if let id = personObj?.personId {
            personObj?.updateProfileImage()
            _fetchedResultsController = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName(String(Messages), predicate: NSPredicate(format: "person.personId = %@", id), sectionNameKeyPath: "msgDate", sorting: [("timestamp", true)])
            _fetchedResultsController?.delegate = self
        }
        setupMessagingView()
        removeActivityIndicator()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.messageReceived(_:)), name: MessagingManager.sharedInstance.messageReceived, object: nil)
        setNavigationBarBackgroundColor(UIColor.whiteColor())

    }

    func messageReceived(notification:NSNotification) {
        if MessagingManager.sharedInstance.isConnected {
            removeActivityIndicator()
        }
    }

    func removeActivityIndicator(){
        if MessagingManager.sharedInstance.isConnected {
            activityIndicator.stopAnimating()
        }
    }
    func uponDidAppear() {
        shouldScroll = false
        MessagingManager.sharedInstance.chattingWithPerson = personObj?.personId
        if let viewcontrls = getNavigationController()?.viewControllers {
            var arr = [UIViewController]()
            for viewCont in viewcontrls {
                if !viewCont.isKindOfClass(MessagingViewController) {
                    arr.append(viewCont)
                }
            }
            arr.append(self)
            getNavigationController()?.viewControllers = arr
        }

    }

    func setupMessagingView() {
        self.senderId = NSUserDefaults.getUserId()
        self.senderDisplayName = ""

        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.collectionViewLayout.messageBubbleFont = UIFont.getAppRegularFontWithSize(17)?.getDynamicSizeFont()
        collectionView.collectionViewLayout.messageBubbleTextViewFrameInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 9)

        collectionView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        inputToolbar.contentView.leftBarButtonItem = nil
        let sendButton = UIButton(frame: CGRect.zero)
        sendButton.setImage(UIImage(named:"send"), forState: .Normal)
        sendButton.imageView?.contentMode = .ScaleAspectFit
        sendButton.sizeToFit()
        inputToolbar.contentView.rightBarButtonItem = sendButton
        inputToolbar.contentView.textView.placeHolder = "Type your message here"
        inputToolbar.contentView.textView.font = UIFont.getAppRegularFontWithSize(17)?.getDynamicSizeFont()
        inputToolbar.maximumHeight = 100
        inputToolbar.preferredDefaultHeight = 50
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        if shouldScroll && keyPath == "contentSize" {
            scrollToBottomAnimated(false)
        }
    }
}

//MARK:- Button action
extension MessagingViewController{
    override func detailsButtonAction(sender: UIButton?) {
        super.detailsButtonAction(sender)
        UIAlertController.showAlertOfStyle(.ActionSheet, Title: nil, Message: nil, OtherButtonTitles: ["VIEW PROFILE", "CLEAR CHAT"], CancelButtonTitle: "CANCEL") { (tappedAtIndex) in
            debugPrint("CLicked at index\(tappedAtIndex)")
        }
    }
}

// MARK: Collection view data source methods
extension MessagingViewController{

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let messageObj = _fetchedResultsController?.objectAtIndexPath(indexPath) as? Messages
        if messageObj?.status == MessageStatus.Sent.rawValue {
            return JSQMessage(senderId: senderId, displayName: "", text: messageObj?.message ?? "")
        }else{
            return JSQMessage(senderId: personObj?.personId ?? "", displayName: "", text: messageObj?.message ?? "")
        }
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return _fetchedResultsController?.sections?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let messageObj = _fetchedResultsController?.objectAtIndexPath(indexPath) as? Messages
        if messageObj?.status == MessageStatus.Sent.rawValue { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return dummAvtarIcon
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        var str = ""
        if indexPath.row == 0 {
            let messageObj = _fetchedResultsController?.objectAtIndexPath(indexPath) as? Messages
            let date = NSDate.dateWithTimeIntervalInMilliSecs(messageObj?.timestamp?.doubleValue ?? 0)
            if date.isToday() {
                str = "Today"
            }else if date.isYesterday(){
                str = "Yesterday"
            }else{
                str = date.longDateString
            }
        }
        return NSAttributedString(string: str)
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let messageObj = _fetchedResultsController?.objectAtIndexPath(indexPath) as? Messages
        let date = NSDate.dateWithTimeIntervalInMilliSecs(messageObj?.timestamp?.doubleValue ?? 0)
        return NSAttributedString(string: date.shortTimeString)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let messageObj = _fetchedResultsController?.objectAtIndexPath(indexPath) as? Messages

        if messageObj?.status == MessageStatus.Sent.rawValue {
            cell.textView?.textColor = UIColor.whiteColor()
        } else {
            cell.textView?.textColor = UIColor.blackColor()
        }

        if let str = personObj?.personImage {
            cell.avatarImageView.sd_setImageWithURL(NSURL(string: str))
        }
        return cell
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {

    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {

    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.row == 0 {
            return 30
        }

        return 0
    }
}
//MARK:- NSFetchedResultsControllerDelegate
extension MessagingViewController:NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.reloadData()
        finishReceivingMessage()
    }
}

// MARK:- Firebase related methods
extension MessagingViewController{

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {

        if NetworkClass.isConnected(true) {
            if let id = personObj?.personId{
                MessagingManager.sharedInstance.send(text, userId: id, trackName: trackName ?? personObj?.lastTrack)
            }
            finishSendingMessage()
        }

    }
}
