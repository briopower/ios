//
//  CommentsModel.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 12/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class CommentsModel: NSObject {
    //MARK:- Variables
    var comment = ""
    var commentedOn:NSDate?
    var commentedBy:String?
}


//MARK:- Additional Methods
extension CommentsModel{
    class func getPayloadDictForCommenting(key:String, commnt:String) -> [String:AnyObject]{
        return ["comment": commnt, "parentKey": key]

    }
    class func getPayloadDict(key:String, cursor:String, query:String = "") -> [String:AnyObject] {
        return ["parentKey": key, "cursor":cursor, "pageSize": 10, "query": query]
    }

    class func getCommentsResponseArray(dict:AnyObject) -> NSArray {
        return dict["commentResultSet"] as? NSArray ?? []
    }
    class func getCommentsCount(dict:AnyObject) -> Int {
        return Int(dict["totalCount"] as? String ?? "") ?? 0
    }

    class func getCommentObj(dict:AnyObject) -> CommentsModel {
        let model = CommentsModel()
        updateCommentObj(model, dict: dict)
        return model
    }

    class func updateCommentObj(commObj:CommentsModel, dict:AnyObject) {
        if let dict = dict as? [String:AnyObject] {
            commObj.commentedBy = dict["from"] as? String
            commObj.commentedOn = NSDate.dateWithTimeIntervalInMilliSecs((dict["timeStamp"] as? NSNumber)?.doubleValue ?? 0)
            commObj.comment = dict["data"]?["message"] as? String ?? ""
        }
    }
}
