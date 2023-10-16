//
//  HomeAssembly.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import Model

enum HomeAssembly { }

extension HomeAssembly {
    static func makeRootCoordinator() -> RootCoordinator {
        RootCoordinator(parent: nil)
    }
    
    static func makeHomeCoordinator(parent: Coordinator?) -> HomeCoordinator {
        HomeCoordinator(parent: parent)
    }
}

extension HomeAssembly {
    static func makeWebPageScreen(transitions: WebPageViewController.Transitions, resolver: Resolver) -> WebPageViewController {
        WebPageViewController(transitions: transitions, webPageInteractor: InteractorsAssembly.webPageInteractor(resolver: resolver))
    }
    
    static func makeHomeScreen(transitions: HomeViewController.Transitions, resolver: Resolver) -> HomeViewController {
        HomeViewController(transitions: transitions, webPageInteractor: InteractorsAssembly.webPageInteractor(resolver: resolver))
    }
}
