//
//  AppDelegate.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        UIWindow.appearance().tintColor = UIColor(red: 45/255, green: 194/255, blue: 160/255, alpha: 1)
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().prefersLargeTitles = true

        window = UIWindow(frame: UIScreen.main.bounds)
        let rootNavigationController = RootNavigationController.instantiate()

        if Auth.auth().currentUser == nil {
            rootNavigationController.setViewControllers([LoginViewController.instantiate()], animated: false)
        } else {
            rootNavigationController.setViewControllers([ListTaskCollectionViewController.instantiate()], animated: false)
        }

        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        return true
    }

}

