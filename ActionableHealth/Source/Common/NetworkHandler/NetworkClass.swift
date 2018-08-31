
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
     static var sessionManager: SessionManager = SessionManager()

    fileprivate class func processResponse(_ request:DataRequest, responseType:ExpectedResponseType, CompletionHandler completion:CompletionHandler?) {

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

    fileprivate class func parseJSON(_ request:DataRequest, CompletionHandler completion:CompletionHandler?){

        request.responseJSON{ response in
            switch response.result {
                
            case .success:
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            case .failure:
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    fileprivate class func parseDATA(_ request:DataRequest, CompletionHandler completion:CompletionHandler?){
        request.responseData{ response in
            switch response.result {
            case .success:
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            case .failure:
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    fileprivate class func parseSTRING(_ request:DataRequest, CompletionHandler completion:CompletionHandler?){
        request.responseString{ response in
            switch response.result {
            case .success:
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            case .failure:
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    fileprivate class func parseNONE(_ request:DataRequest, CompletionHandler completion:CompletionHandler?){
        request.response{ response in
            if response.error == nil{
                processCompletionWithStatus(true, response: response, CompletionHandler: completion)
            }else{
                processCompletionWithStatus(false, response: response, CompletionHandler: completion)
            }
        }
    }

    fileprivate class func processEncodingResult(_ encodingResult:SessionManager.MultipartFormDataEncodingResult, responseType:ExpectedResponseType, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?) {

        switch encodingResult {
        case .success(let upload, _, _):

            upload.validate()
            upload.uploadProgress { (progress) in
                // code
            }
//            upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
//                if let progress = progress{
//                    progress(totalBytesSent: totalBytesWritten, totalBytesExpectedToSend: totalBytesExpectedToWrite)
//                }
//            }

            processResponse(upload, responseType: responseType, CompletionHandler: completion)

        case .failure(_):
            processCompletionWithStatus(false, response: nil, CompletionHandler: completion)
        }
    }

    fileprivate class func processCompletionWithStatus(_ status:Bool, response:Any?, CompletionHandler completion:CompletionHandler?) {

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if let completion = completion{

            var responseObj:AnyObject? = nil
            var error:NSError? = nil
            var statusCode:Int? = nil

//            if let temp = response as? DataResponse<AnyObject> {
//                responseObj = temp.result.value
//                error = temp.result.error as NSError?
//                statusCode = temp.response?.statusCode
//            }else if let temp = response as? DataResponse<NSData> {
//                responseObj = temp.result.value
//                error = temp.result.error as NSError?
//                statusCode = temp.response?.statusCode
//            }else if let temp = response as? DataResponse<String> {
//                responseObj = temp.result.value as AnyObject
//                error = temp.result.error as NSError?
//                statusCode = temp.response?.statusCode
//            }else if let temp = response as? (URLRequest?, HTTPURLResponse?, Data?, NSError?) {
//                responseObj = NSArray(objects: temp.1 ?? HTTPURLResponse(), temp.2 ?? Data())
//                error = temp.3
//                statusCode = temp.1?.statusCode
//            }
            if let temp = response as? DataResponse<Any> {
                responseObj = temp.result.value as AnyObject
                error = temp.result.error as NSError?
                statusCode = temp.response?.statusCode
            }else if let temp = response as? DataResponse<NSData> {
                responseObj = temp.result.value
                error = temp.result.error as NSError?
                statusCode = temp.response?.statusCode
            }else if let temp = response as? DataResponse<String> {
                responseObj = temp.result.value as AnyObject
                error = temp.result.error as NSError?
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

    class func sendRequest(URL url:String, RequestType requestType:HTTPMethod, ResponseType responseType:ExpectedResponseType = .json , Parameters parameters: AnyObject? = nil, Headers headers: [String: String]? = nil , networkActivityIndicatorVisible: Bool = true, CompletionHandler completion:CompletionHandler?){
        
        if networkActivityIndicatorVisible{
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        if let dataRequest = getRequest(requestType, responseType: responseType, URLString: url, headers: headers, parameters: parameters){
            dataRequest.validate()
            processResponse(dataRequest, responseType: responseType, CompletionHandler: completion)
        }
    }

    class func getRequest(
        _ method: HTTPMethod,
        responseType:ExpectedResponseType = .json,
        URLString: String,
        headers: [String: String]? = nil,
        parameters:AnyObject? = nil)
        -> DataRequest?{

            
//            let mutableURLRequest: NSMutableURLRequest = NSMutableURLRequest.init(url: url)
//
////            if type(of: URLString) == NSMutableURLRequest.self {
////                mutableURLRequest = URLString as! NSMutableURLRequest
////            } else if type(of: URLString) == URLRequest.self {
////                mutableURLRequest = (URLString as! NSURLRequest).URLRequest
////            } else {
////                mutableURLRequest = NSMutableURLRequest(URL: URL(string: URLString.URLString)!)
////            }
//            mutableURLRequest = NSMutableURLRequest(url: URLString.asURL().absoluteURL)
//            mutableURLRequest.httpMethod = method.rawValue
//
//            let allHeaders = getUpdatedHeader(headers,requestType: method)
//
//            for (headerField, headerValue) in allHeaders {
//                mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
//            }
//
//            if let parameters = parameters {
//                do{
//                    if JSONSerialization.isValidJSONObject(parameters) {
//                        mutableURLRequest.httpBody =  try JSONSerialization.data(withJSONObject: parameters, options: [])
//                    }else{
//                        debugPrint("Problem in Parameters")
//                    }
//                }catch{
//                    debugPrint("Problem in Parameters")
//                }
//            }
//
//            mutableURLRequest.timeoutInterval = 360
//            return mutableURLRequest
            let allHeaders = getUpdatedHeader(headers,requestType: method)
            guard let url = URL(string: URLString) else{ return nil }
            let completeUrl = URLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            var dataRequest:DataRequest? = nil
            if parameters == nil || parameters is Parameters {
                let params = parameters as? Parameters
                dataRequest = NetworkClass.sessionManager.request (
                    completeUrl!,
                    method: method,
                    parameters: params,
                    encoding: JSONEncoding.default,
                    headers: allHeaders
                )
            } else {
                var request = URLRequest(url: url)
                request.httpMethod = method.rawValue
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters!)
                dataRequest = NetworkClass.sessionManager.request(request)
            }
            return dataRequest
    }
}

//MARK:- Image Uploading Methods
extension NetworkClass{
    class func sendImageRequest(URL url:String, RequestType requestType:HTTPMethod, ResponseType responseType:ExpectedResponseType = .none, Parameters parameters: [String: AnyObject]? = nil, Headers headers: [String: String]? = [:], ImageData imageData:Data?, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?){

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //let request = getRequest(requestType, responseType: responseType, URLString: url, headers: headers, parameters: parameters as AnyObject)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let imageData = imageData{
                multipartFormData.append(imageData, withName: "profileImage", fileName: "profileImage", mimeType: "image/jpeg")
            }
            if let parameters = parameters{
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
        }, to:url)
        { (result) in
            processEncodingResult(result, responseType: responseType, ProgressHandler: progress, CompletionHandler: completion)
        }
        
//        Alamofire.upload(request,
//
//                         multipartFormData: {(multipartFormData) in
//                            if let imageData = imageData{
//                                multipartFormData.appendBodyPart(
//                                    data: imageData,
//                                    name: "profileImage",
//                                    fileName: "profileImage",
//                                    mimeType: "image/png")
//                            }
//                            if let parameters = parameters{
//                                for (key, value) in parameters {
//                                    if let data = value.dataUsingEncoding(NSUTF8StringEncoding){
//                                        multipartFormData.appendBodyPart(data: data, name: key)
//                                    }
//                                }
//                            }},
//
//                         encodingMemoryThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold)
//        { (encodingResult) in
//            processEncodingResult(encodingResult, responseType: responseType, ProgressHandler: progress, CompletionHandler: completion)
//        }
        
    }
    class func sendBlogsImageRequest(URL url:String, RequestType requestType:HTTPMethod, ResponseType responseType:ExpectedResponseType = .none, Parameters parameters: [String: AnyObject]? = nil, Headers headers: [String: String]? = [:], ImageData imageData:Data?, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //let request = getRequest(requestType, responseType: responseType, URLString: url, headers: headers, parameters: parameters as AnyObject)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let imageData = imageData{
                multipartFormData.append(imageData, withName: "blogImage", fileName: "blogImage", mimeType: "image/jpeg")
            }
            if let parameters = parameters{
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
        }, to:url)
        { (result) in
            processEncodingResult(result, responseType: responseType, ProgressHandler: progress, CompletionHandler: completion)
        }
    }
}

//MARK:- Video Uploading Methods
extension NetworkClass{
    class func sendVideoRequest(URL url:String, RequestType requestType:HTTPMethod, ResponseType responseType:ExpectedResponseType = .json, Parameters parameters: [String: AnyObject]? = nil, Headers headers: [String: String]? = nil, VideoUrl videoUrl:URL, ProgressHandler progress:ProgressHandler?, CompletionHandler completion:CompletionHandler?){

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let videoData = try? Data(contentsOf: videoUrl)
        let request = getRequest(requestType, responseType: responseType, URLString: url, headers: headers, parameters: parameters as AnyObject)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let videoData = videoData{
                multipartFormData.append(videoData, withName: "defaultVideo", fileName: "defaultVideo.mov", mimeType: "video/quicktime")
            }
            if let parameters = parameters{
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
        }, to:url)
        { (result) in
            processEncodingResult(result, responseType: responseType, ProgressHandler: progress, CompletionHandler: completion)
        }
        
    }
}

//MARK:- Reachablity Methods
extension NetworkClass{
    class func isConnected(_ showAlert:Bool)->Bool{

        var val = false

        let reachability = Reachability()!
        
//        reachability.whenReachable = { reachability in
//            if reachability.connection == .wifi {
//                val = true
//            } else {
//                val = true
//            }
//        }
//        reachability.whenUnreachable = { _ in
//           val = false
//        }
        if reachability.connection != .none{
            if reachability.connection == .wifi{
                val = true
            } else {
                // cellular data
                val = true
            }
        }else{
            // not reachable
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
    class func getUpdatedHeader(_ header: [String: String]?, requestType:HTTPMethod) -> [String: String] {
        
        var updatedHeader:[String:String] = [:]
        switch requestType {
        case .post:
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
