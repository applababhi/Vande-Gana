//
//  AppDelegate.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Kingfisher
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        // Use Firebase library to configure PUSH APIs
        FirebaseApp.configure()        
        Messaging.messaging().delegate = self
        
        registerForPushNotificationSettings()

        if let uuid:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            if uuid != ""
            {
                // DIRECTLY SHOW APP DASHBOARD
            //    let vc: DashobaordVC = AppStoryBoards.Dashboard.instance.instantiateViewController(withIdentifier: "DashobaordVC_ID") as! DashobaordVC
             //   k_window.rootViewController = vc
                let tab: HomeTabBarVC = AppStoryBoards.HomeTabBarVC.instance.instantiateViewController(withIdentifier: "HomeTabBarVC_ID") as! HomeTabBarVC
                k_window.rootViewController = tab
            }
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
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate
{
    func registerForPushNotificationSettings()
    {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    // Called when Device Token is received
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        //send this device token to server
        
        //set apns token in messaging
        Messaging.messaging().apnsToken = deviceToken
        
        //get FCM token
        if let token = Messaging.messaging().fcmToken {
            print("Firebase registration token: \(token)")
            deviceToken_FCM = token
        }
    }
    
    // Firebase registration TOken
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        print("Firebase registration token: \(fcmToken)")
        deviceToken_FCM = fcmToken
    }
    
    // Called if unable to register for APNS.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register Push : \(error)")
    }
    
    // On Receiving notification following delegate will call
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        print("Notification Payload Received -> ",aps)
        
        if let dictAlert:[String:Any] = aps["alert"] as? [String:Any]
        {
            if let str:String = dictAlert["body"] as? String
            {
                if str == "First Notification1"
                {
                    // Take to some VC
                    print("> > Take to some VC from Push - -")
                }
            }
        }
        
    }
}
