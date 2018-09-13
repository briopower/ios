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
    var commentedOn:Date?
    var commentedBy:String?
}


//MARK:- Additional Methods
extension CommentsModel{
    class func getPayloadDictForCommenting(_ key:String, commnt:String) -> [String:AnyObject]{
        
        return ["comment": commnt as AnyObject, "parentKey": key as AnyObject]

    }
    class func getPayloadDict(_ key:String, cursor:String, query:String = "") -> [String:AnyObject] {
        return ["parentKey": key as AnyObject, "cursor":cursor as AnyObject, "pageSize": 10 as AnyObject, "query": query as AnyObject]
    }

    class func getCommentsResponseArray(_ dict:AnyObject) -> NSArray {
        return dict["commentResultSet"] as? NSArray ?? []
    }
    class func getCommentsCount(_ dict:AnyObject) -> Int {
        return Int(dict["totalCount"] as? String ?? "") ?? 0
    }

    class func getCommentObj(_ dict:AnyObject) -> CommentsModel {
        let model = CommentsModel()
        updateCommentObj(model, dict: dict)
        return model
    }

    class func updateCommentObj(_ commObj:CommentsModel, dict:AnyObject) {
        if let dict = dict as? [String:AnyObject] {
            commObj.commentedBy = dict["from"] as? String
            commObj.commentedOn = Date.dateWithTimeIntervalInMilliSecs((dict["timeStamp"] as? NSNumber)?.doubleValue ?? 0)
            
            commObj.comment = dict["data"]?["message"] as? String ?? ""
        }
    }
}
