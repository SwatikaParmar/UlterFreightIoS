//
//  AppDelegate.swift
//  FreightPulse
//
//
//

import UIKit
import IQKeyboardManagerSwift
import LGSideMenuController
import UserNotifications
import GoogleMaps
import GooglePlaces
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = .black
        IQKeyboardManager.shared.enableAutoToolbar =  true
        
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            // Fallback on earlier versions
        }
        GMSServices.provideAPIKey(GlobalConstants.GoogleWebAPIKey)
        GMSPlacesClient.provideAPIKey(GlobalConstants.GoogleWebAPIKey)
         
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Permission for push notifications denied.")
            }
        }
        
        
        "Your function heightForView seems intended to calculate the height required to display a given string with a certain font and width. However, there are several issues and confusions in the implementation. Here's a breakdown with corrections and improvements:".heightForView(text: "Your function heightForView seems intended to calculate the height required to display a given string with a certain font and width. However, there are several issues and confusions in the implementation. Here's a breakdown with corrections and improvements:", font: UIFont(name: FontName.Inter.Medium, size: 15)!, width: 500)
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification and perform necessary actions
        completionHandler()
    }


}

