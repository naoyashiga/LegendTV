//
//  AppDelegate.swift
//  LegendTV
//
//  Created by naoyashiga on 2015/08/09.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let font = UIFont(name: FontSet.bold, size: 14)
        if let font = font {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.navigationTitleColor()]
        }
        
        UITabBar.appearance().tintColor = UIColor.tabBarItemTintColor()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        
        setSchemaVersion(1, Realm.defaultPath,
            { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if oldSchemaVersion < 1 {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        VideoPlayManager.sharedManager.remoteControlReceivedWithEvent(event)
    }
}

