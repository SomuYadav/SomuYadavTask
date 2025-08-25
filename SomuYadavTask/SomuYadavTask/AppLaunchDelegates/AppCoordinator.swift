//
//  Untitled.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    
    @MainActor
    func start() {
        let viewController = USTabBarController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
