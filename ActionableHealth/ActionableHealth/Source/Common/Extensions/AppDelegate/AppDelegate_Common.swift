//
//  AppDelegate_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit
import CoreLocation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


//MARK:- Additional methods
extension AppDelegate{
    class func getAppDelegateObject() -> AppDelegate?
    {
        return UIApplication.shared.delegate as? AppDelegate
    }
}

//MARK:- Location Manager Methods
extension AppDelegate: CLLocationManagerDelegate{

    func locationManagerSetup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        geoCoder.reverseGeocodeLocation(newLocation) { (placemarks:[CLPlacemark]?, error:NSError?) in
            if placemarks?.count > 0 && error == nil{
                self.currentPlacemark = placemarks![0]
            }
        } as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler
    }
}
