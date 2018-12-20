//
//  AppDelegate.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 14/11/18.
//  Copyright © 2018 Bruno Cruz. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.barTintColor = .yellow
        
        let moviesGrid = MoviesGridViewController()
        moviesGrid.title = "Movies"
        //FIXME:- pass correct image
        moviesGrid.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(), tag: 0)
        
        let controllers = [moviesGrid]
        tabBarController.viewControllers = controllers.map({
            UINavigationController(rootViewController: $0)
        })

        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
        return true
    }

}