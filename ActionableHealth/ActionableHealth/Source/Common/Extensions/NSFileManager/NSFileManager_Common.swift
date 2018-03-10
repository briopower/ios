//
//  NSFileManager_Common.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 23/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

extension NSFileManager{
    class func save(data:NSData, fileName:String, mimeType:String, path:String? = nil) -> String? {

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil)?.takeRetainedValue(){
            if let ext = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassFilenameExtension)?.takeRetainedValue(){
                return save(data, fileName: fileName, fileExtension: String(ext),path: path)
            }
        }
        return nil
    }

    class func save(data:NSData, fileName:String, fileExtension:String, path:String? = nil) -> String?{
        if let filePath = path ?? NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first{
            if let completeFilePath = NSURL(string: filePath)?.URLByAppendingPathComponent("\(fileName).\(fileExtension)")?.relativeString {
                if !defaultManager().fileExistsAtPath(completeFilePath){
                    if data.writeToFile(completeFilePath, atomically: false){
                        return completeFilePath
                    }
                }else{
                    return completeFilePath
                }
            }
        }
        return nil
    }
}
