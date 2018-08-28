//
//  BlogCommentComments.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/28/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import Foundation

class BlogCommentsManager {
    
    var cursor: String?
    var totalCount: String?
    var commentResultSet: [BlogComment]?
    var returnedCount: String?
    
    
    init() {
        cursor = ""
        totalCount = "0"
        returnedCount = "0"
        commentResultSet = [BlogComment]()
    }
    class func initWithDict(dict: [String : Any])-> BlogCommentsManager{
        let blogCommentsManager = BlogCommentsManager()
        blogCommentsManager.cursor = dict["cursor"] as? String
        blogCommentsManager.totalCount = dict["totalCount"] as? String
        blogCommentsManager.returnedCount = dict["returnedCount"] as? String
        if let resultSet = dict["commentResultSet"] as? [[String : Any]]{
            blogCommentsManager.commentResultSet = BlogComment.getBlogCommentsArray(array: resultSet)
        }
        return blogCommentsManager
    }
    
}

class BlogComment {
    var id: String?
    var createdBy: String?
    var blogId: String?
    var description: String?
    var createdDate: Date?
    
    init() {
        id = ""
        createdBy = ""
        blogId = ""
        description = ""
        createdDate = Date()
    }
   
    class func initWithDict(dict: [String : Any])-> BlogComment{
        let blogComment = BlogComment()
        blogComment.id = dict["id"] as? String
        blogComment.description = dict["description"] as? String
        blogComment.createdDate = Date.dateWithTimeIntervalInMilliSecs((dict["createdDate"] as? NSNumber)?.doubleValue ?? 0)
        blogComment.blogId = dict["blogId"] as? String
        blogComment.createdBy = dict["createdBy"] as? String
        return blogComment
    }
    class func getBlogCommentsArray(array: [[String : Any]]) -> [BlogComment] {
        var BlogCommentsArray = [BlogComment]()
        for element in array{
            BlogCommentsArray.append(BlogComment.initWithDict(dict: element))
        }
        return BlogCommentsArray
    }
}


