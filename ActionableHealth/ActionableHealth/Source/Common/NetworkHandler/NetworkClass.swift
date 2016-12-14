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

//MARK:- Request Methods
class NetworkClass:NSObject  {

    class func sendRequest(URL url:String, RequestType type:Alamofire.Method, Parameters parameters: AnyObject? = nil, Headers headers: [String: String]? = nil, CompletionHandler completion:CompletionHandler?){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let request = getRequest(type, url, headers:getUpdatedHeader(headers) , parameters: parameters)
        Alamofire.request(request)
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
}

//MARK:- Reachablity Method
extension NetworkClass{
    class func isConnected(showAlert:Bool)->Bool{
        var val = false
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            switch reachability.currentReachabilityStatus {
            case .NotReachable:
                val = false
            default:
                val = true
            }
        }catch {
            val = false
        }

        if !val && showAlert {
            UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "No Internet Connection", completion: nil)
        }
        return val
    }
}

//MARK:- Additional Methods
extension NetworkClass{
    class func getUpdatedHeader(header: [String: String]?) -> [String: String] {
        var updatedHeader = ["Content-Type":"application/json"]
        if NSUserDefaults.isLoggedIn(){
            updatedHeader["ahw-token"] = NSUserDefaults.getUserToken()
        }

        if let arr = header?.keys {
            for key in arr {
                updatedHeader[key] = header![key]
            }
        }
        return updatedHeader
    }

    private class func getRequest(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
          headers: [String: String]? = nil,
          parameters:AnyObject?)
        -> NSMutableURLRequest
    {
        let mutableURLRequest: NSMutableURLRequest

        if URLString.dynamicType == NSMutableURLRequest.self {
            mutableURLRequest = URLString as! NSMutableURLRequest
        } else if URLString.dynamicType == NSURLRequest.self {
            mutableURLRequest = (URLString as! NSURLRequest).URLRequest
        } else {
            mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: URLString.URLString)!)
        }

        mutableURLRequest.HTTPMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        if let parameters = parameters {
            do{
                if NSJSONSerialization.isValidJSONObject(parameters) {
                    mutableURLRequest.HTTPBody =  try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
                }else{
                    debugPrint("Problem in Parameters")
                }
            }catch{
                debugPrint("Problem in Parameters")
            }
        }
        mutableURLRequest.timeoutInterval = 360
        return mutableURLRequest
    }
    
}
