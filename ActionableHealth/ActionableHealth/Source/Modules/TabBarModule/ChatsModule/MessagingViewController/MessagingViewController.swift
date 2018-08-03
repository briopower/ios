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
    var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var personObj:Person?
    var trackName:String?

    let outgoingBubbleImageView = JSQMessagesBubbleImage(messageBubble: UIImage(named:"sentMessage")!, highlightedImage: UIImage(named:"sentMessage")!)
    let incomingBubbleImageView = JSQMessagesBubbleImage(messageBubble: UIImage(named:"recievedMessage")!, highlightedImage: UIImage(named:"recievedMessage")!)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var text = Contact.getNameForContact(personObj?.personId ?? "") ?? personObj?.personId ?? ""
        if let lastTrackName = trackName ?? personObj?.lastTrack {
            text += " (\(lastTrackName))"
        }
        titleLabel.text = text
        titleLabel.sizeToFit()
        titleView.frame = CGRect(origin: CGPoint.zero, size: titleLabel.frame.size)
        setNavigationBarWithTitleView(titleView, LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        personObj?.markAllAsRead()
        AppDelegate.getAppDelegateObject()?.saveContext()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        uponDidAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
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
            _fetchedResultsController = CoreDataOperationsClass.getFectechedResultsControllerWithEntityName("Messages", predicate: NSPredicate(format: "person.personId = %@", id), sectionNameKeyPath: "msgDate", sorting: [("timestamp", true)])
            _fetchedResultsController?.delegate = self
        }
        setupMessagingView()
        removeActivityIndicator()
        NotificationCenter.default.addObserver(self, selector: #selector(self.messageReceived(_:)), name: NSNotification.Name(rawValue: MessagingManager.sharedInstance.messageReceived), object: nil)
        setNavigationBarBackgroundColor(UIColor.white)

    }

    @objc func messageReceived(_ notification:Notification) {
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
                if !viewCont.isKind(of: MessagingViewController.self) {
                    arr.append(viewCont)
                }
            }
            arr.append(self)
            getNavigationController()?.viewControllers = arr
        }

    }

    func setupMessagingView() {
        self.senderId = UserDefaults.getUserId()
        self.senderDisplayName = ""

        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        collectionView.backgroundColor = UIColor.clear
        collectionView.collectionViewLayout.messageBubbleFont = UIFont.getAppRegularFontWithSize(17)?.getDynamicSizeFont()
        collectionView.collectionViewLayout.messageBubbleTextViewFrameInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 9)

        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        inputToolbar.contentView.leftBarButtonItem = nil
        let sendButton = UIButton(frame: CGRect.zero)
        sendButton.setImage(UIImage(named:"send"), for: UIControlState())
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.sizeToFit()
        inputToolbar.contentView.rightBarButtonItem = sendButton
        inputToolbar.contentView.textView.placeHolder = "Type your message here"
        inputToolbar.contentView.textView.font = UIFont.getAppRegularFontWithSize(17)?.getDynamicSizeFont()
        inputToolbar.maximumHeight = 100
        inputToolbar.preferredDefaultHeight = 50
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        if shouldScroll && keyPath == "contentSize" {
            scrollToBottom(animated: false)
        }
    }
}

//MARK:- Button action
extension MessagingViewController{
    override func detailsButtonAction(_ sender: UIButton?) {
        super.detailsButtonAction(sender)
        UIAlertController.showAlertOfStyle(.actionSheet, Title: nil, Message: nil, OtherButtonTitles: ["VIEW PROFILE", "CLEAR CHAT"], CancelButtonTitle: "CANCEL") { (tappedAtIndex) in
            debugPrint("CLicked at index\(tappedAtIndex)")
        }
    }
}

// MARK: Collection view data source methods
extension MessagingViewController{

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let messageObj = _fetchedResultsController?.object(at: indexPath) as? Messages
        if messageObj?.status == MessageStatus.Sent.rawValue {
            return JSQMessage(senderId: senderId, displayName: "", text: messageObj?.message ?? "")
        }else{
            return JSQMessage(senderId: personObj?.personId ?? "", displayName: "", text: messageObj?.message ?? "")
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _fetchedResultsController?.sections?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let messageObj = _fetchedResultsController?.object(at: indexPath) as? Messages
        if messageObj?.status == MessageStatus.Sent.rawValue { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return dummAvtarIcon
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        var str = ""
        if indexPath.row == 0 {
            let messageObj = _fetchedResultsController?.object(at: indexPath) as? Messages
            let date = Date.dateWithTimeIntervalInMilliSecs(messageObj?.timestamp?.doubleValue ?? 0)
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

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let messageObj = _fetchedResultsController?.object(at: indexPath) as? Messages
        let date = Date.dateWithTimeIntervalInMilliSecs(messageObj?.timestamp?.doubleValue ?? 0)
        return NSAttributedString(string: date.shortTimeString)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let messageObj = _fetchedResultsController?.object(at: indexPath) as? Messages

        if messageObj?.status == MessageStatus.Sent.rawValue {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }

        if let str = personObj?.personImage {
            cell.avatarImageView.sd_setImage(with: URL(string: str))
        }
        return cell
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, at indexPath: IndexPath!) {

    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {

    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.row == 0 {
            return 30
        }

        return 0
    }
}
//MARK:- NSFetchedResultsControllerDelegate
extension MessagingViewController:NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
        finishReceivingMessage()
    }
}

// MARK:- Firebase related methods
extension MessagingViewController{

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {

        if NetworkClass.isConnected(true) {
            if let id = personObj?.personId{
                MessagingManager.sharedInstance.send(text, userId: id, trackName: trackName ?? personObj?.lastTrack)
            }
            finishSendingMessage()
        }

    }
}
