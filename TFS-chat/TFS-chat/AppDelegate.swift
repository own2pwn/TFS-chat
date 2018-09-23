//
//  AppDelegate.swift
//  TFS-chat
//
//  Created by Evgeniy on 23/09/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        log.debug()

        return true
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        log.debug()

        return true
    }

    func applicationDidBecomeActive(_: UIApplication) { log.debug() }

    func applicationDidEnterBackground(_: UIApplication) { log.debug() }

    func applicationWillResignActive(_: UIApplication) { log.debug() }

    func applicationWillEnterForeground(_: UIApplication) { log.debug() }

    func applicationWillTerminate(_: UIApplication) { log.debug() }
}
