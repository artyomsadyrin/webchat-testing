//
//  HomeCoordinator.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 10.06.21.
//

import Model

final class HomeCoordinator: NavigationCoordinator {
    override init(parent: Coordinator?) {
        super.init(parent: parent)
        
        showHomeScreen()
    }
}

private extension HomeCoordinator {
    func showHomeScreen() {
        let viewController = HomeAssembly.makeHomeScreen()
        
        viewController.transitions.openWebPage = { [weak self] in
            self?.showWebPageScreen(config: $0)
        }
        
        pushViewController(viewController)
    }
    
    func showWebPageScreen(config: WebPageConfig) {
        let viewController = HomeAssembly.makeWebPageScreen(config: config)
        
        viewController.transitions.close = { [weak self] in
            self?.popViewController(animated: true)
        }
        
        pushViewController(viewController, animated: true)
    }
}
