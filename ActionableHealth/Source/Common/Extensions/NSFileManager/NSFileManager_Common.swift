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

extension FileManager{
    class func save(_ data:Data, fileName:String, mimeType:String, path:String? = nil) -> String? {

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue(){
            if let ext = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassFilenameExtension)?.takeRetainedValue(){
                return save(data, fileName: fileName, fileExtension: String(ext),path: path)
            }
        }
        return nil
    }

    class func save(_ data:Data, fileName:String, fileExtension:String, path:String? = nil) -> String?{
        if let filePath = path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
            if let completeFilePath = URL(string: filePath)?.appendingPathComponent("\(fileName).\(fileExtension)").relativeString {
                if !`default`.fileExists(atPath: completeFilePath){
                    if (try? data.write(to: URL(fileURLWithPath: completeFilePath), options: [])) != nil{
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
