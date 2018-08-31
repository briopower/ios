//
//  CommonMethods.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class CommonMethods: NSObject {
    class func addShadowToView(_ containerView:UIView) {
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 1.2
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.clipsToBounds = false
    }

    class func addShadowToTabBar(_ containerView:UIView?) {
        containerView?.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        containerView?.layer.shadowOpacity = 1
        containerView?.layer.shadowRadius = 2
        containerView?.clipsToBounds = false
    }

    class func setCornerRadius(_ containerView:UIView) {
        containerView.layer.cornerRadius = 1
        containerView.clipsToBounds = true
    }
    class func getDictFromJSONString(jsonString: String?)-> [String:Any]{
        guard let jsonStr = jsonString else{
            return [String : Any]()
        }
        
        if let data = jsonStr.data(using: .utf8){
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                {
                    return jsonArray
                } else {
                    print("bad json cannot convert to Dictionary")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return [String : Any]()
    }
    
    class func getIntFromJSONString(jsonString: String?)-> Int{
        guard let jsonStr = jsonString else{
            return 0
        }
        
        if let data = jsonStr.data(using: .utf8){
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Int
                {
                    return jsonArray
                } else {
                    print("bad json cannot convert to Int")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return 0
    }
    
}
