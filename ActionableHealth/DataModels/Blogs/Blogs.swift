//
//  Blogs.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/27/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import Foundation

class BlogsManager {
    
    var cursor: String?
    var totalCount: String?
    var blogResultSet: [Blog]?
    var returnedCount: String?
    
    
    init() {
        cursor = ""
        totalCount = "0"
        returnedCount = "0"
        blogResultSet = [Blog]()
    }
    class func initWithDict(dict: [String : Any])-> BlogsManager{
        let blogsManager = BlogsManager()
        blogsManager.cursor = dict["cursor"] as? String
        blogsManager.totalCount = dict["totalCount"] as? String
        blogsManager.returnedCount = dict["returnedCount"] as? String
        if let resultSet = dict["blogResultSet"] as? [[String : Any]]{
            blogsManager.blogResultSet = Blog.getblogsArray(array: resultSet)
        }
        return blogsManager
    }
    
}

class Blog {
    var id: String?
    var userId: String?
    var trackId: String?
    var description: String?
    var title: String?
    var createdDate: Date?
    var isSelcetedForDelete = false
    init() {
        id = ""
        userId = ""
        trackId = ""
        description = ""
        title = ""
        createdDate = Date()
    }
    class func initWithDict(dict: [String : Any])-> Blog{
        let blog = Blog()
        blog.id = dict["id"] as? String
        blog.description = dict["description"] as? String
        blog.createdDate = Date.dateWithTimeIntervalInMilliSecs((dict["createdDate"] as? NSNumber)?.doubleValue ?? 0)
        blog.trackId = dict["trackId"] as? String
        blog.userId = dict["userId"] as? String
        blog.title = dict["title"] as? String
        
        return blog
    }
    class func getblogsArray(array: [[String : Any]]) -> [Blog] {
        var blogsArray = [Blog]()
        for element in array{
            blogsArray.append(Blog.initWithDict(dict: element))
        }
        return blogsArray
    }
}


