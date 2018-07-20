//
//  CommentsManager.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 30/01/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class CommentsManager: NSObject {
    //MARK:- Variables
    static let sharedInstance = CommentsManager()
    var ref: DatabaseReference?
    var commentId:String! = ""
    let commentReceived = "commentReceivedNotifiaction"
    fileprivate var _refHandle: DatabaseHandle?
    fileprivate var chanelToObserve:String{
        get{
            return "comments/\(commentId)"
        }
    }
}

//MARK:- Private methods
extension CommentsManager{
    fileprivate func configureDatabase() {

        if ref == nil {
            ref = Database.database().reference()
        }

        // Listen for new messages in the Firebase database
        _refHandle = self.ref?.child(chanelToObserve).observe(.childAdded, with:
            { (snapshot:DataSnapshot) in
                if let data = snapshot.valueInExportFormat() as? [String:AnyObject]{
                    if let type = MessageType(rawValue: data["data"]?["type"] as? String ?? ""){
                        switch type{
                        case .comment:
                            NotificationCenter.default.post(name: Notification.Name(rawValue: self.commentReceived), object: data)
                        default:
                            break
                        }
                    }
                }
            }, withCancel:
            { (error:NSError) in
                debugPrint("------------DATABASE SYNC ISSUE COMMENT--------------\(error)")
                } as! (Error) -> Void)
        // TODO
    }

    fileprivate func sendComment(_ comment:String) {
       let key = commentId.replacingOccurrences(of: "_\(UserDefaults.getUserId())", with: "")
        let objToSend:[String:AnyObject] = ["data":["key":key, "message":comment, "type": MessageType.comment.rawValue] as AnyObject,
                                            "from": UserDefaults.getUserId() as AnyObject,
                                            "priority": "high" as AnyObject,
                                            "timeStamp": Date().timeIntervalInMilliSecs() as AnyObject]

        NetworkClass.sendRequest(URL: Constants.URLs.comment, RequestType: .post, Parameters: CommentsModel.getPayloadDictForCommenting(key, commnt: comment) as AnyObject, Headers: nil, CompletionHandler: {
            (status, responseObj, error, statusCode) in
            debugPrint("send comment \(statusCode)")
        })
        self.ref?.child(chanelToObserve).childByAutoId().setValue(objToSend)
    }

}

//MARK:- Public methods
extension CommentsManager{

    func openCommentSession(_ commentID:String) {
        closeCommentSession()
        self.commentId = commentID
        self.configureDatabase()
    }

    func closeCommentSession() {
        if let handler = _refHandle {
            ref?.child(chanelToObserve).removeObserver(withHandle: handler)
            ref?.removeAllObservers()
            ref = nil
            _refHandle = nil
            commentId = ""
        }
    }

    func send(_ comment:String) {
        sendComment(comment)
    }
}
