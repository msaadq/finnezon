//
//  SceneCoordinator.swift
//  Finnezon
//
//  Created by Saad Qureshi on 04/04/2022.
//

import UIKit
import Combine

final class SceneCoordinator: CoordinatorProtocol {
    private let window: UIWindow
    private let dependencyContainer: DependencyContainerProtocol
    private var cancellables = Set<AnyCancellable>()

    private(set) var navigationController = UINavigationController()
    private(set) var parentCoordinator: CoordinatorProtocol?
    private(set) var childCoordinators = [CoordinatorProtocol]()

    private let tabBarController = UITabBarController()

    // MARK: - Life Cycle

    init(window: UIWindow, dependencyContainer: DependencyContainerProtocol) {
        self.window = window
        self.dependencyContainer = dependencyContainer
    }

    // MARK: - CoordinatorProtocol

    func start() {
        self.setupTabs()
        self.didLaunchHome()
    }

    func childDidFinish(_ child: CoordinatorProtocol) {
        if navigationController.presentedViewController === child.navigationController {
            child.navigationController.dismiss(animated: true)
        }

        childCoordinators.removeAll { $0 === child }
    }

    // MARK: - SceneCoordinator

    func setupTabs() {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        tabBarController.viewControllers = [navigationController]
    }

    func didLaunchHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController, dependencyContainer: dependencyContainer)
        homeCoordinator.start()
    }

    func didLaunchFavourites() {

    }
}
