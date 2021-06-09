//
//  RootCoordinator.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import Model

final class RootCoordinator: ContainerCoordinator {
    func start(at window: UIWindow?) {
        window?.rootViewController = baseViewController
        showHomeScreen()
        window?.makeKeyAndVisible()
    }
}

private extension RootCoordinator {
    func showWebPageScreen(config: WebPageConfig) {
        let viewController = HomeAssembly.makeWebPageScreen(config: config)
        
        viewController.transitions.close = { [weak self] in
            self?.dismissModalController()
        }
        
        presentModal(controller: viewController, presentationStyle: .fullScreen)
    }
    
    func showHomeScreen() {
        let viewController = HomeAssembly.makeHomeScreen()
        
        viewController.transitions.openWebPage = { [weak self] in
            self?.showWebPageScreen(config: $0)
        }
        
        setContentCoordinator(nil)
        containerViewController.setContentViewController(viewController)
    }
}
