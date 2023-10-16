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
    
    override func registerContent() {
        super.registerContent()
        
        register(DataManagersAssembly.webPageCache())
    }
}

private extension HomeCoordinator {
    func showHomeScreen() {
        let transitions = HomeViewController.Transitions(
            openWebPage: { [weak self] in self?.showWebPageScreen() }
        )
        let viewController = HomeAssembly.makeHomeScreen(transitions: transitions, resolver: self)
        
        pushViewController(viewController)
    }
    
    func showWebPageScreen() {
        let transitions = WebPageViewController.Transitions(
            close: { [weak self] in self?.popViewController(animated: true) }
        )
        let viewController = HomeAssembly.makeWebPageScreen(transitions: transitions, resolver: self)
        
        pushViewController(viewController, animated: true)
    }
}
