//
//  AppDelegate.swift
//  APNSTestAgain
//
//  Created by Chris Wu on 1/18/19.
//  Copyright © 2019 KDP. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    fileprivate func ResetBadge() {
        print("Reset Badge = 0")
        print("UIApplication.shared.applicationIconBadgeNumber = \(UIApplication.shared.applicationIconBadgeNumber)")
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications()
        
        // When the app launch after user tap on notification (originally was not running / not in background)
//        if(launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil){
//            //Confirmed works when the app has a cold start
//            //Or the app is brought up after the lock screen?
//            print("----> Notification received while the APP wasn't running")
//            ResetBadge()
//        }

        // Override point for customization after application launch.
        
        return true
    }
    

    
    // This function will be called when the app receive notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // show the notification alert (banner), and with sound
        print("-40> Notication caught in 'willPresent' when the APP is active")
        completionHandler([.alert, .sound, .badge]) //Set this to .alert, then tap on it will lead to -1>
        //completionHandler([.sound]) //Sound only, so no alert to tap on.
    }
    
    fileprivate func respondeOnTapping() {
        if (self.window?.rootViewController is ViewController) {
            let alert = UIAlertController(
                title: "Notification Received",
                message: "Do you want to refresh for delivery updates?",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(
                title: "Refresh",
                style: UIAlertAction.Style.default,
                handler: { (action) in
                    //The Refershing Screen Code
            }))
            
            alert.addAction(UIAlertAction(
                title: "Ignore",
                style: UIAlertAction.Style.destructive,
                handler: { (action) in
                    UIApplication.shared.applicationIconBadgeNumber = 0
            }))
            
            alert.addAction(UIAlertAction(
                title: "Remind Me Later",
                style: UIAlertAction.Style.cancel))
            
            self.window?.rootViewController!.present(alert, animated: true)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        
        print("Notification Reveived!")
        
        if(application.applicationState == .active){
            //Verified happened, APP is active while notication received, willPresent did presented it and user tapped on that banner
            print("-1> FOREground tapping just happened")            
            respondeOnTapping()
        }
        
        if(application.applicationState == .inactive)
        {
            //Varified happend, APP was inactive when notification arrived and was brought active by the notification
            print("-2> Inactive tapping just happened")
            respondeOnTapping()
        }
        
        if(application.applicationState == .background)
        {
            //This will never happen. For the application state of your app to become UIApplicaitonStateBackground,
            //  your application would have to register for a background process.
            print("-3> Background tapping just happened")
            ResetBadge()
        }
        
        /* Change root view controller to a specific viewcontroller */
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // let vc = storyboard.instantiateViewController(withIdentifier: "ViewControllerStoryboardID") as? ViewController
        // self.window?.rootViewController = vc
        
        completionHandler()
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }


}

