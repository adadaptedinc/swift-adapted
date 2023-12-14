//
//  AppDelegate.swift
//  SwiftAdapted
//
//  Created by Brett Clifton on 11/16/23.
//

import UIKit
import adadapted_swift_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AaSdkSessionListener, AaSdkEventListener, AaSdkAdditContentListener {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AdAdapted
            .withAppId(key: "7D58810X6333241C")
            .inEnv(env: AdAdapted.Env.DEV)
            .enableKeywordIntercept(value: true)
            .setSdkSessionListener(listener: self)
            .setSdkEventListener(listener: self)
            .setSdkAdditContentListener(listener: self)
            .start()
        
        //AdAdaptedListManager.itemAddedToList(item: "stuff", list: "list")
        
        
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
        content.acknowledge()
        print(String(format: "%d item(s) added to Default List", listItems.count))
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
