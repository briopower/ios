//
//  NetworkClass.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//


typealias CompletionHandler = (status:Bool, responseObj:AnyObject?,error: NSError?, statusCode:Int?) -> Void
typealias ProgressHandler = (totalBytesSent:Int64, totalBytesExpectedToSend:Int64)-> Void

import Alamofire

class NetworkClass:NSObject  {
    class func sendRequest(URL url:String, RequestType type:Alamofire.Method, Parameters parameters: [String: AnyObject]? = nil, Headers headers: [String: String]? = nil, CompletionHandler completion:CompletionHandler?){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(type, url, parameters: parameters, encoding: .JSON, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if completion != nil{
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        completion!(status: true, responseObj: response.result.value, error: response.result.error, statusCode: response.response?.statusCode)
                    }
                case .Failure:
                    if completion != nil{
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        completion!(status: false, responseObj: response.result.value, error: response.result.error, statusCode: response.response?.statusCode)
                    }
                }
        }
    }

    class func sendImageRequest(URL url:String, RequestType type:Alamofire.Method, Parameters parameters: [String: AnyObject]? = nil, Headers headers: [String: String]? = nil,ImageName imageName:String?, ImageData imageData:NSData?, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.upload(type, url, headers: headers, multipartFormData:
            {(multipartFormData) in
                if imageData != nil{
                    multipartFormData.appendBodyPart(data: imageData!, name: imageName! , fileName: "image.png", mimeType: "image/png")
                }
                if parameters != nil{
                    for (key, value) in parameters! {
                        multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                    }
                }

            }, encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold)
        {(encodingResult) in

            switch encodingResult {
            case .Success(let upload, _, _):
                upload.validate()
                upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                    if progress != nil{
                        progress!(totalBytesSent: totalBytesWritten, totalBytesExpectedToSend: totalBytesExpectedToWrite)
                    }
                }
                upload.responseJSON {response in
                    switch response.result {
                    case .Success:
                        if completion != nil{
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            completion!(status: true, responseObj: response.result.value, error: response.result.error, statusCode: response.response?.statusCode)
                        }
                    case .Failure:
                        if completion != nil{
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            completion!(status: false, responseObj: response.result.value, error: response.result.error, statusCode: response.response?.statusCode)
                        }
                    }
                }
            case .Failure:
                if completion != nil{
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    completion!(status: false, responseObj: nil, error: nil, statusCode: nil)
                }
            }

        }
    }

    class func sendVideoRequest(URL url:String, RequestType type:Alamofire.Method, Parameters parameters: [String: AnyObject]? = nil, Headers headers: [String: String]? = nil,VideoName videoName:String, VideoUrl videoUrl:NSURL, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?){

        let videoData = NSData(contentsOfURL: videoUrl)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.upload(type, url, headers: headers, multipartFormData:
            {(multipartFormData) in
                if videoData != nil{
                    multipartFormData.appendBodyPart(data: videoData!, name: videoName , fileName: videoName, mimeType: "video/quicktime")
                }
                if parameters != nil{
                    for (key, value) in parameters! {
                        multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                    }
                }

            }, encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold)
        {(encodingResult) in

            switch encodingResult {
            case .Success(let upload, _, _):
                upload.validate()
                upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                    if progress != nil{
                        progress!(totalBytesSent: totalBytesWritten, totalBytesExpectedToSend: totalBytesExpectedToWrite)
                    }
                }
                upload.responseJSON {response in
                    switch response.result {
                    case .Success:
                        if completion != nil{
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            completion!(status: true, responseObj: response.result.value, error: response.result.error, statusCode: response.response?.statusCode)
                        }
                    case .Failure:
                        if completion != nil{
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            completion!(status: false, responseObj: response.result.value, error: response.result.error, statusCode: response.response?.statusCode)
                        }
                    }
                }
            case .Failure:
                if completion != nil{
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    completion!(status: false, responseObj: nil, error: nil, statusCode: nil)
                }
            }

        }
    }
    class func isConnected()->Bool{
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        }catch {
            return false
        }
        switch reachability.currentReachabilityStatus {
        case .NotReachable:
            return false
        default:
            return true
        }
    }
}
