//
//  AppDelegate.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 04/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    var currentPlacemark:CLPlacemark?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        forEasyLoading()

        setupOnAppLauch()

        debugPrint(applicationLibraryDirectory.absoluteURL)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
        debugPrint("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        MessagingManager.sharedInstance.connectToFcm()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        startSyncing()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.finoit.ActionableHealth" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var applicationLibraryDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("ActionableHealth", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationLibraryDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            if let tempError = error as? NSError{
                dict[NSUnderlyingErrorKey] = tempError
            }
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    lazy var bgManagedObjectContext: NSManagedObjectContext = {
        var bgContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        bgContext.parentContext = AppDelegate.getAppDelegateObject()?.managedObjectContext
        return bgContext
    }()

    lazy var abManagedObjectContext: NSManagedObjectContext = {
        var bgContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        bgContext.parentContext = AppDelegate.getAppDelegateObject()?.managedObjectContext
        return bgContext
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

//MARK: - Notification Methods
extension AppDelegate{

    func registerForPushNotifications() {
        let application = UIApplication.sharedApplication()

        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.Alert, .Badge, .Sound]
            UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions(authOptions, completionHandler: { (val, error) in

            })
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.currentNotificationCenter().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self

        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        // Let FCM know about the message for analytics etc.`
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            debugPrint("Message ID: \(messageID)")
        }

        // Print full message.
        debugPrint(userInfo)
    }
}

//MARK:- Additonal methods
extension AppDelegate{
    func forEasyLoading() {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.commentsView) as? CommentsViewController {
            viewCont.view.userInteractionEnabled = true
        }

        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackFileView) as? TrackFilesViewController {
            viewCont.view.userInteractionEnabled = true
        }
    }

    func startSyncing(){
        ContactSyncManager.sharedInstance.checkForDeletedContacts()
        ContactSyncManager.sharedInstance.syncContacts()
    }

    func setupOnAppLauch() {
        if NSUserDefaults.isLoggedIn() {
            // Add observer for InstanceID token refresh callback.
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotification(_:)), name: kFIRInstanceIDTokenRefreshNotification, object: nil)
            registerForPushNotifications()
            MessagingManager.sharedInstance.openChatSession()
        }else{
            MessagingManager.sharedInstance.closeChatSession()
        }
    }
}

//MARK:- UNUserNotificationCenterDelegate
extension AppDelegate:UNUserNotificationCenterDelegate{

}
//MARK:- FIRMessagingDelegate
extension AppDelegate:FIRMessagingDelegate{
    func applicationReceivedRemoteMessage(remoteMessage: FIRMessagingRemoteMessage){
        debugPrint(remoteMessage.appData)
    }
}

//MARK:- Notification Methods
extension AppDelegate{
    func tokenRefreshNotification(not:NSNotification) {
        MessagingManager.sharedInstance.connectToFcm()        
    }
}
