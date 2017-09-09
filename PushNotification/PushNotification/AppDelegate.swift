//
//  AppDelegate.swift
//  PushNotification
//
//  Created by SUN YU on 8/9/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        if #available(iOS 10, *) {
            
           UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        
            // iOS 9 support 
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new

        
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
  
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
        switch application.applicationState {
            case .active:
                //app is currently active, can update badges count here
                application.applicationIconBadgeNumber = 0
                //when app is active, will not notification, can create alert here to notify user
            case .background:
                print("The app is in background")
                application.applicationIconBadgeNumber += 1
            case .inactive:
                //app is transitioning from background to foreground when user interactive with notifications
                application.applicationIconBadgeNumber = 0
            
                // basically, if you want to jump to a certain view, you do need to consider if the view if one of rootview,
                // don't try to jump to a view that break thing
     
                //jump to the a certain view
//                window = UIWindow(frame: UIScreen.main.bounds)
//            
//                let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//            
//                let notificationVC = myStoryBoard.instantiateViewController(withIdentifier: "notificationVC") as! SecondVC
//
//                if let message = userInfo["payload"] as? String
//                {
//                    print(message)
//                    notificationVC.pushInfo = message
//                }
//            
//                self.window?.rootViewController = notificationVC
//                window?.makeKeyAndVisible()
            
            
        
            
        }
        
    
        
        
    }

}

