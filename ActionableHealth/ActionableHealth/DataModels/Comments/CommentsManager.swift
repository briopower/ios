//
//  CommentsManager.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 30/01/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit
import Firebase

class CommentsManager: NSObject {
    //MARK:- Variables
    static let sharedInstance = CommentsManager()
    var ref: FIRDatabaseReference?
    var commentId:String! = ""
    let commentReceived = "commentReceivedNotifiaction"
    private var _refHandle: FIRDatabaseHandle?
    private var chanelToObserve:String{
        get{
            return "comments/\(commentId)"
        }
    }
}

//MARK:- Private methods
extension CommentsManager{
    private func configureDatabase() {

        if ref == nil {
            ref = FIRDatabase.database().reference()
        }

        // Listen for new messages in the Firebase database
        _refHandle = self.ref?.child(chanelToObserve).observeEventType(.ChildAdded, withBlock:
            { (snapshot:FIRDataSnapshot) in
                if let data = snapshot.valueInExportFormat() as? [String:AnyObject]{
                    if let type = MessageType(rawValue: data["data"]?["type"] as? String ?? ""){
                        switch type{
                        case .comment:
                            NSNotificationCenter.defaultCenter().postNotificationName(self.commentReceived, object: data)
                        default:
                            break
                        }
                    }
                }
            }, withCancelBlock:
            { (error:NSError) in
                debugPrint("------------DATABASE SYNC ISSUE COMMENT--------------\(error)")
        })
    }

    private func sendComment(comment:String) {
       let key = commentId.stringByReplacingOccurrencesOfString("_\(NSUserDefaults.getUserId())", withString: "")
        let objToSend:[String:AnyObject] = ["data":["key":key, "message":comment, "type": MessageType.comment.rawValue],
                                            "from": NSUserDefaults.getUserId(),
                                            "priority": "high",
                                            "timeStamp": NSDate().timeIntervalInMilliSecs()]

        NetworkClass.sendRequest(URL: Constants.URLs.comment, RequestType: .POST, Parameters: CommentsModel.getPayloadDictForCommenting(key, commnt: comment), Headers: nil, CompletionHandler: {
            (status, responseObj, error, statusCode) in
            debugPrint("send comment \(statusCode)")
        })
        self.ref?.child(chanelToObserve).childByAutoId().setValue(objToSend)
    }
}

//MARK:- Public methods
extension CommentsManager{

    func openCommentSession(commentID:String) {
        closeCommentSession()
        self.commentId = commentID
        self.configureDatabase()
    }

    func closeCommentSession() {
        if let handler = _refHandle {
            ref?.child(chanelToObserve).removeObserverWithHandle(handler)
            ref?.removeAllObservers()
            ref = nil
            _refHandle = nil
            commentId = ""
        }
    }

    func send(comment:String) {
        sendComment(comment)
    }
}
