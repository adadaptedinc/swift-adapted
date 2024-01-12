//
//  AppDelegate.swift
//  SwiftAdapted
//
//  Created by Brett Clifton on 11/16/23.
//

import UIKit
import adadapted_swift_sdk
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AaSdkSessionListener, AaSdkEventListener, AaSdkAdditContentListener {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AdAdapted
            .withAppId(key: "7D58810X6333241C")
            .inEnv(env: AdAdapted.Env.DEV)
            .enableKeywordIntercept(value: true)
            .enablePayloads(value: true)
            .setSdkSessionListener(listener: self)
            .setSdkEventListener(listener: self)
            .setSdkAdditContentListener(listener: self)
            .start()
        
        DispatchQueue.main.async { //ONLY used for payload testing, the SDK will never request this.
            ATTrackingManager.requestTrackingAuthorization() { status in
                switch status {
                case .authorized:
                    // User granted permission
                    print("Tracking authorized.")
                case .denied:
                    // User denied permission
                    print("Tracking denied.")
                case .restricted:
                    // Tracking is restricted
                    print("Tracking restricted.")
                case .notDetermined:
                    // Tracking permission not determined yet
                    print("Tracking permission not determined.")
                @unknown default:
                    break
                }
            }
        }
        
        return true
    }
    
    func onHasAdsToServe(hasAds: Bool, availableZoneIds: Array<String>) {
        print("Has Ads To Serve: \(hasAds)")
        print("The following zones have ads to serve: \(availableZoneIds)")
    }
    
    func onNextAdEvent(zoneId: String, eventType: String) {
        print("Ad \(eventType) for Zone \(zoneId)")
    }
    
    func onContentAvailable(content: AddToListContent) {
        let listItems = content.getItems()
        let itemTitle = listItems.first?.title ?? ""
        content.acknowledge()
        print(String(format: "%d item(s) added to Default List", listItems.count))
        Toast.showToast(message: itemTitle + " received from payload.", duration: 2.0)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                //todo call universal link parser
                return true
            }
        }
        return false
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
}
