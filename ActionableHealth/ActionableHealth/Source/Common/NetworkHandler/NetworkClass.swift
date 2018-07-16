
//
//  NetworkClass.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

enum ExpectedResponseType:Int {
    case json, data, string, none, count
}
typealias CompletionHandler = (_ status:Bool, _ responseObj:AnyObject?,_ error: NSError?, _ statusCode:Int?) -> Void
typealias ProgressHandler = (_ totalBytesSent:Int64, _ totalBytesExpectedToSend:Int64)-> Void

import Alamofire

//MARK:- Private Methods
class NetworkClass:NSObject  {

    fileprivate class func processResponse(_ request:Alamofire.Request, responseType:ExpectedResponseType, CompletionHandler completion:CompletionHandler?) {

        switch responseType {
        case .json:
            parseJSON(request, CompletionHandler: completion)
        case .data:
            parseDATA(request, CompletionHandler: completion)
        case .string:
            parseSTRING(request, CompletionHandler: completion)
        case .none:
            parseNONE(request, CompletionHandler: completion)
        default:
            break
        }
    }

    fileprivate class func parseJSON(_ request:Alamofire.Request, CompletionHandler completion:CompletionHandler?){

        request.responseJSON{ response in
            switch response.result {
            case .Success:
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            case .Failure:
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    fileprivate class func parseDATA(_ request:Alamofire.Request, CompletionHandler completion:CompletionHandler?){
        request.responseData{ response in
            switch response.result {
            case .Success:
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            case .Failure:
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    fileprivate class func parseSTRING(_ request:Alamofire.Request, CompletionHandler completion:CompletionHandler?){
        request.responseString{ response in
            switch response.result {
            case .Success:
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            case .Failure:
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    fileprivate class func parseNONE(_ request:Alamofire.Request, CompletionHandler completion:CompletionHandler?){
        request.response{ response in
            if response.3 == nil{
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            }else{
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    fileprivate class func processEncodingResult(_ encodingResult:Manager.MultipartFormDataEncodingResult, responseType:ExpectedResponseType, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?) {

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

    fileprivate class func processCompletionWithStatus(_ status:Bool, response:Any?, CompletionHandler completion:CompletionHandler?) {

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
            }else if let temp = response as? (URLRequest?, HTTPURLResponse?, Data?, NSError?) {
                responseObj = NSArray(objects: temp.1 ?? HTTPURLResponse(), temp.2 ?? Data())
                error = temp.3
                statusCode = temp.1?.statusCode
            }

            completion(status, responseObj, error, statusCode)
        }
    }
}

//MARK:- Request Methods
extension NetworkClass{

    class func sendRequest(URL url:String, RequestType requestType:Alamofire.Method, ResponseType responseType:ExpectedResponseType = .json , Parameters parameters: AnyObject? = nil, Headers headers: [String: String]? = nil, CompletionHandler completion:CompletionHandler?){

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let request = getRequest(requestType, responseType: responseType, URLString: url, headers: headers, parameters: parameters)
        let afRequest = Alamofire.request(request)
        afRequest.validate()

        processResponse(afRequest, responseType: responseType, CompletionHandler: completion)
    }

    class func getRequest(
        _ method: Alamofire.Method,
        responseType:ExpectedResponseType = .json,
        URLString: URLStringConvertible,
        headers: [String: String]? = nil,
        parameters:AnyObject? = nil)
        -> NSMutableURLRequest{

            let mutableURLRequest: NSMutableURLRequest

            if type(of: URLString) == NSMutableURLRequest.self {
                mutableURLRequest = URLString as! NSMutableURLRequest
            } else if type(of: URLString) == URLRequest.self {
                mutableURLRequest = (URLString as! NSURLRequest).URLRequest
            } else {
                mutableURLRequest = NSMutableURLRequest(URL: URL(string: URLString.URLString)!)
            }

            mutableURLRequest.HTTPMethod = method.rawValue

            let allHeaders = getUpdatedHeader(headers,requestType: method)

            for (headerField, headerValue) in allHeaders {
                mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }

            if let parameters = parameters {
                do{
                    if JSONSerialization.isValidJSONObject(parameters) {
                        mutableURLRequest.httpBody =  try JSONSerialization.data(withJSONObject: parameters, options: [])
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
    class func sendImageRequest(URL url:String, RequestType requestType:Alamofire.Method, ResponseType responseType:ExpectedResponseType = .none, Parameters parameters: [String: AnyObject]? = nil, Headers headers: [String: String]? = [:], ImageData imageData:Data?, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?){

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
    class func sendVideoRequest(URL url:String, RequestType requestType:Alamofire.Method, ResponseType responseType:ExpectedResponseType = .json, Parameters parameters: [String: AnyObject]? = nil, Headers headers: [String: String]? = nil, VideoUrl videoUrl:URL, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?){

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let videoData = try? Data(contentsOf: videoUrl)
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
    class func isConnected(_ showAlert:Bool)->Bool{

        var val = false
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            switch reachability.currentReachabilityStatus {
            case .notReachable:
                val = false
            default:
                val = true
            }
        }catch {
            val = false
        }

        if !val && showAlert {
          //  UIAlertController.showAlertOfStyle(UIAlertControllerStyle.Alert, Message: "No Internet Connection", completion: nil)
            UIView.showToast("No Internet Connection !!", theme: Theme.warning)
        }
        return val
    }
}

//MARK:- Additional Methods
extension NetworkClass{
    class func getUpdatedHeader(_ header: [String: String]?, requestType:Alamofire.Method) -> [String: String] {
        
        var updatedHeader:[String:String] = [:]
        switch requestType {
        case .POST:
            updatedHeader["Content-Type"] = "application/json"
        default:
            break
        }
        if UserDefaults.isLoggedIn(){
            updatedHeader["ahw-token"] = UserDefaults.getUserToken()
        }
        if let arr = header?.keys {
            for key in arr {
                updatedHeader[key] = header![key]
            }
        }
        return updatedHeader
    }
}
