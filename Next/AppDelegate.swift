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
    let environment: Environment = UserDefaultsEnvironment()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        UIWindow.appearance().tintColor = UIColor(red: 45/255, green: 194/255, blue: 160/255, alpha: 1)
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().prefersLargeTitles = true

        window = UIWindow(frame: UIScreen.main.bounds)
        let rootNavigationController = RootNavigationController.instantiate()

        if let user = environment.getCurrentUser() {
            rootNavigationController.setViewControllers([ListTaskCollectionViewController.instantiate(withUser: user)], animated: false)
        } else {
            rootNavigationController.setViewControllers([LoginViewController.instantiate()], animated: false)
        }

        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        return true
    }

    // just for development
    func signOut() {
        try? Auth.auth().signOut()
        environment.removeCurrentUser()
    }

}

