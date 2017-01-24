//
//  NetworkClass.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

enum ExpectedResponseType:Int {
    case JSON, DATA, STRING, NONE, Count
}
typealias CompletionHandler = (status:Bool, responseObj:AnyObject?,error: NSError?, statusCode:Int?) -> Void
typealias ProgressHandler = (totalBytesSent:Int64, totalBytesExpectedToSend:Int64)-> Void

import Alamofire

//MARK:- Private Methods
class NetworkClass:NSObject  {

    private class func processResponse(request:Alamofire.Request, responseType:ExpectedResponseType, CompletionHandler completion:CompletionHandler?) {

        switch responseType {
        case .JSON:
            parseJSON(request, CompletionHandler: completion)
        case .DATA:
            parseDATA(request, CompletionHandler: completion)
        case .STRING:
            parseSTRING(request, CompletionHandler: completion)
        case .NONE:
            parseNONE(request, CompletionHandler: completion)
        default:
            break
        }
    }

    private class func parseJSON(request:Alamofire.Request, CompletionHandler completion:CompletionHandler?){

        request.responseJSON{ response in
            switch response.result {
            case .Success:
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            case .Failure:
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    private class func parseDATA(request:Alamofire.Request, CompletionHandler completion:CompletionHandler?){
        request.responseData{ response in
            switch response.result {
            case .Success:
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            case .Failure:
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    private class func parseSTRING(request:Alamofire.Request, CompletionHandler completion:CompletionHandler?){
        request.responseString{ response in
            switch response.result {
            case .Success:
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            case .Failure:
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    private class func parseNONE(request:Alamofire.Request, CompletionHandler completion:CompletionHandler?){
        request.response{ response in
            if response.3 == nil{
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            }else{
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    private class func processEncodingResult(encodingResult:Manager.MultipartFormDataEncodingResult, responseType:ExpectedResponseType, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?) {

        switch encodingResult {
        case .Success(let upload, _, _):

            upload.validate()
            upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                if let progress = progress{
                    progress(totalBytesSent: totalBytesWritten, totalBytesExpectedToSend: totalBytesExpectedToWrite)
                }
            }

            processResponse(upload, responseType: responseType, CompletionHandler: completion)

        case .Failure:
            processCompletionWithStatus(false, response: nil, CompletionHandler: completion)
        }
    }

    private class func processCompletionWithStatus(status:Bool, response:Any?, CompletionHandler completion:CompletionHandler?) {

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if let completion = completion{

            var responseObj:AnyObject? = nil
            var error:NSError? = nil
            var statusCode:Int? = nil

            if let temp = response as? Alamofire.Response<AnyObject, NSError> {
                responseObj = temp.result.value
                error = temp.result.error
                statusCode = temp.response?.statusCode
            }else if let temp = response as? Alamofire.Response<NSData, NSError> {
                responseObj = temp.result.value
                error = temp.result.error
                statusCode = temp.response?.statusCode
            }else if let temp = response as? Alamofire.Response<String, NSError> {
                responseObj = temp.result.value
                error = temp.result.error
                statusCode = temp.response?.statusCode
            }else if let temp = response as? (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) {
                responseObj = NSArray(objects: temp.1 ?? NSHTTPURLResponse(), temp.2 ?? NSData())
                error = temp.3
                statusCode = temp.1?.statusCode
            }

            completion(status: status, responseObj: responseObj, error: error, statusCode: statusCode)
        }
    }
}

//MARK:- Request Methods
extension NetworkClass{

    class func sendRequest(URL url:String, RequestType requestType:Alamofire.Method, ResponseType responseType:ExpectedResponseType = .JSON , Parameters parameters: AnyObject? = nil, Headers headers: [String: String]? = nil, CompletionHandler completion:CompletionHandler?){

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let request = getRequest(requestType, responseType: responseType, URLString: url, headers: headers, parameters: parameters)
        let afRequest = Alamofire.request(request)
        afRequest.validate()

        processResponse(afRequest, responseType: responseType, CompletionHandler: completion)
    }

    class func getRequest(
        method: Alamofire.Method,
        responseType:ExpectedResponseType = .JSON,
        URLString: URLStringConvertible,
        headers: [String: String]? = nil,
        parameters:AnyObject? = nil)
        -> NSMutableURLRequest{

            let mutableURLRequest: NSMutableURLRequest

            if URLString.dynamicType == NSMutableURLRequest.self {
                mutableURLRequest = URLString as! NSMutableURLRequest
            } else if URLString.dynamicType == NSURLRequest.self {
                mutableURLRequest = (URLString as! NSURLRequest).URLRequest
            } else {
                mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: URLString.URLString)!)
            }

            mutableURLRequest.HTTPMethod = method.rawValue

            let allHeaders = getUpdatedHeader(headers,requestType: method)

            for (headerField, headerValue) in allHeaders {
                mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
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

//MARK:- Image Uploading Methods
extension NetworkClass{
    class func sendImageRequest(URL url:String, RequestType requestType:Alamofire.Method, ResponseType responseType:ExpectedResponseType = .NONE, Parameters parameters: [String: AnyObject]? = nil, Headers headers: [String: String]? = [:], ImageData imageData:NSData?, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?){

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let request = getRequest(requestType, responseType: responseType, URLString: url, headers: headers, parameters: parameters)
        Alamofire.upload(request,

                         multipartFormData: {(multipartFormData) in
                            if let imageData = imageData{
                                multipartFormData.appendBodyPart(
                                    data: imageData,
                                    name: "profileImage",
                                    fileName: "profileImage",
                                    mimeType: "image/png")
                            }
                            if let parameters = parameters{
                                for (key, value) in parameters {
                                    if let data = value.dataUsingEncoding(NSUTF8StringEncoding){
                                        multipartFormData.appendBodyPart(data: data, name: key)
                                    }
                                }
                            }},

                         encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold)
        { (encodingResult) in
            processEncodingResult(encodingResult, responseType: responseType, ProgressHandler: progress, CompletionHandler: completion)
        }
    }
}

//MARK:- Video Uploading Methods
extension NetworkClass{
    class func sendVideoRequest(URL url:String, RequestType requestType:Alamofire.Method, ResponseType responseType:ExpectedResponseType = .JSON, Parameters parameters: [String: AnyObject]? = nil, Headers headers: [String: String]? = nil, VideoUrl videoUrl:NSURL, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?){

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let videoData = NSData(contentsOfURL: videoUrl)
        let request = getRequest(requestType, responseType: responseType, URLString: url, headers: headers, parameters: parameters)
        Alamofire.upload(request,

                         multipartFormData: {(multipartFormData) in
                            if let videoData = videoData{
                                multipartFormData.appendBodyPart(
                                    data: videoData,
                                    name: "defaultVideo",
                                    fileName: "defaultVideo.mov",
                                    mimeType: "video/quicktime")
                            }
                            if let parameters = parameters{
                                for (key, value) in parameters {
                                    if let data = value.dataUsingEncoding(NSUTF8StringEncoding){
                                        multipartFormData.appendBodyPart(data: data, name: key)
                                    }
                                }
                            }},

                         encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold)
        { (encodingResult) in
            processEncodingResult(encodingResult, responseType: responseType, ProgressHandler: progress, CompletionHandler: completion)
        }
    }
}

//MARK:- Reachablity Methods
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
          //  UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "No Internet Connection", completion: nil)
            UIView.showToastWith("No Internet Connection !!")
        }
        return val
    }
}

//MARK:- Additional Methods
extension NetworkClass{
    class func getUpdatedHeader(header: [String: String]?, requestType:Alamofire.Method) -> [String: String] {
        
        var updatedHeader:[String:String] = [:]
        switch requestType {
        case .POST:
            updatedHeader["Content-Type"] = "application/json"
        default:
            break
        }
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
}
