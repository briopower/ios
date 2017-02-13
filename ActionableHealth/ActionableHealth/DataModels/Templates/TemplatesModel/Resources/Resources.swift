//
//  Resources.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/02/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

class Resources: NSObject {
    //MARK:- Variables
    var fileName:String?
    var blobKey:String?

}

//MARK:- Additional methods
extension Resources{
    class func getResourceUsingObj(dict:AnyObject) -> Resources {
        let model = Resources()
        updateObj(model, dict:dict)
        return model
    }

    class func updateObj(model:Resources, dict:AnyObject) {
        model.blobKey = dict["blobKey"] as? String
    }
}
