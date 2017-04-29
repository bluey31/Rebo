//
//  AppDelegate.swift
//  Survival of Rebo
//
//  Created by Brendon Warwick on 24/03/2017.
//  Copyright © 2017 Brendon Warwick. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    /**
     * Pauses the game when the app goes into a unactive state
     */
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        gameField.pause(forcePause: true)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        gameField.pause(forcePause: true)
    }
}

