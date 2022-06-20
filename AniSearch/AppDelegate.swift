//
//  AppDelegate.swift
//  AniSearch
//
//  Created by Sabrina Chen on 3/13/22.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let parseConfig = ParseClientConfiguration{
            $0.applicationId = "95XQgzinTN8nCnZ4TFYMhDksr3rlQaWvIUaBvl65"
            $0.clientKey = "SafrQkezZzUXWVjNCwkVfE0tN4KahsTbpgS6Bd8H"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
        UserDefaults.standard.register(defaults: [
            "Background_R" : 255.0,
            "Background_G" : 255.0,
            "Background_B" : 255.0,
            "HomeDefault" : "/seasons/now",
            "toDetails": false,
            "Filters" : "",
            "Liked":[]
            ]
        )
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


}

