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
    func showHomeScreen() {
        let coordinator = HomeAssembly.makeHomeCoordinator(parent: self)
        setContentCoordinator(coordinator)
    }
}
