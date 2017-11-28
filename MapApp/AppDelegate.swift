//
//  AppDelegate.swift
//  MapApp
//
//  Created by Valeev Anatoliy on 17/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate{

    var window: UIWindow?
    
    var _mapManager:BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Localizator.instance.currentLanguage = Locale.current.languageCode!
        
        _mapManager = BMKMapManager()
        /**
         * All interfaces of Baidu Maps SDK support Baidu coordinates (BD09) and State Bureau coordinates (GCJ02). Use this method to set the coordinate type you are using.
         * The default is BD09 (BMK_COORDTYPE_BD09LL) coordinates.
         * If you need to use GCJ02 coordinates, you need to set CoordinateType to: BMK_COORDTYPE_COMMON.
         */
        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORDTYPE_BD09LL) {
            print("Latitude and longitude type is set successfully");
        } else {
            print("Latitude and longitude type setting failed");
        }
        // If you want to focus on the network and authorization verification events, please set generalDelegate parameters
        let ret = _mapManager?.start("Please enter your key", generalDelegate: self)
        if ret == false {
            print("manager start failed!")
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


}

