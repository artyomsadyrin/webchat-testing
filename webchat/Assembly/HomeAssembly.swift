//
//  HomeAssembly.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import Model

final class HomeAssembly { }

extension HomeAssembly {
    static func makeRootCoordinator() -> RootCoordinator {
        RootCoordinator(parent: nil)
    }
    
    static func makeHomeCoordinator(parent: Coordinator?) -> HomeCoordinator {
        HomeCoordinator(parent: parent)
    }
}

extension HomeAssembly {
    static func makeWebPageScreen(config: WebPageConfig) -> WebPageViewController {
        WebPageViewController(config: config)
    }
    
    static func makeHomeScreen() -> HomeViewController {
        HomeViewController()
    }
}
