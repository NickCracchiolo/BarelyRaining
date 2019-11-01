//
//  AppDelegate.swift
//  BarelyRaining
//
//  Created by Nick Cracchiolo on 8/29/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let model:ForecastDataModel = ForecastDataModel()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.checkForNilUserDefaults()
        if #available(iOS 13.0, *) {
            self.registerBGTasks()
        }
        guard let root = self.window?.rootViewController as? UINavigationController else { return false }
        if let vc = root.viewControllers.first as? WeatherViewController {
            vc.dataModel = self.model
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
        if #available(iOS 13.0, *) {
            self.scheduleAppRefresh()
        }
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

    private func checkForNilUserDefaults() {
        let defaultsURL = Bundle.main.url(forResource: "Defaults", withExtension: "plist")
        let dictionary  = NSDictionary(contentsOf: defaultsURL!) as! Dictionary<String, Any>
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    @available(iOS 13.0, *)
    private func registerBGTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.njc.app.BarelyRaining.refresh", using: DispatchQueue.global()) { (task) in
            self.handleAppRefresh(task)
        }
    }
    
    @available(iOS 13.0, *)
    private func handleAppRefresh(_ task:BGTask) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.addOperation {
            self.model.reload()
        }

        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        let lastOperation = queue.operations.last
        lastOperation?.completionBlock = {
            task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
        }

        scheduleAppRefresh()
    }
    
    @available(iOS 13.0, *)
    private func scheduleAppRefresh() {
        do {
            let request = BGAppRefreshTaskRequest(identifier: "com.njc.app.BarelyRaining.refresh")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 3600)
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print(error)
        }
    }
}

