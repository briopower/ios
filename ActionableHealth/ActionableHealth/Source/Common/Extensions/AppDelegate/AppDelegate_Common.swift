//
//  AppDelegate_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit
import CoreLocation

//MARK:- Additional methods
extension AppDelegate{
    class func getAppDelegateObject() -> AppDelegate?
    {
        return UIApplication.sharedApplication().delegate as? AppDelegate
    }
}

//MARK: - Notification Methods
extension AppDelegate{

    func registerForPushNotifications() {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        NSUserDefaults.setDeviceToken(deviceToken)

    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        
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

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        geoCoder.reverseGeocodeLocation(newLocation) { (placemarks:[CLPlacemark]?, error:NSError?) in
            if placemarks?.count > 0 && error == nil{
                self.currentPlacemark = placemarks![0]
            }
        }
    }
}