//
//  AppDelegate.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var rootCoordinator: RootCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        rootCoordinator = HomeAssembly.makeRootCoordinator()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        rootCoordinator.start(at: window)
        
        setupNavigationBarAppearance()
        
        return true
    }
}

private extension AppDelegate {
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()
        
        appearance.barStyle = .default
        appearance.prefersLargeTitles = false
        
        // Hide back button indicator
        appearance.backIndicatorImage = UIImage()
        appearance.backIndicatorTransitionMaskImage = UIImage()
    }
}
