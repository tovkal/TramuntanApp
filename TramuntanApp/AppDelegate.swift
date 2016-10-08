//
//  AppDelegate.swift
//  TramuntanApp
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        // If no default datasource is set, use muntanyes8
        if Utils.sharedInstance().getUserSetting(datasourceSettingKey) == nil {
            Utils.sharedInstance().saveUserSetting(datasourceSettingKey, value: "muntanyes8" as AnyObject)
        }
        
        LocationController.sharedInstance().startLocation()
        Store.sharedInstance()
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            return handleShortcut(shortcutItem)
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
    }
    
    // MARK: - Quick action handling methods
    
    fileprivate func handleShortcut(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = QuickAction(fullIdentifier: shortcutType) else {
            return false
        }
        
        return selectTabBarItemForIdentifier(shortcutIdentifier)
    }
    
    fileprivate func selectTabBarItemForIdentifier(_ quickAction: QuickAction) -> Bool {
        guard let tabBar: UITabBarController = self.window?.rootViewController as? UITabBarController else {
            Crashlytics.sharedInstance().recordError(NSError(domain: "AppDelegate", code: 1, userInfo: [NSLocalizedDescriptionKey: "RootviewController is not a UITabBarController"]))
            return false
        }
        
        switch(quickAction) {
        case .OpenAR:
            tabBar.selectedIndex = 0
            return true
        case .OpenMap:
            tabBar.selectedIndex = 1
            return true
        }
    }
}
