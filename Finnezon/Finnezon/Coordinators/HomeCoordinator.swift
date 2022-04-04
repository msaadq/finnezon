//
//  HomeCoordinator.swift
//  Finnezon
//
//  Created by Saad Qureshi on 04/04/2022.
//

import UIKit
import Combine

final class HomeCoordinator: CoordinatorProtocol {
    private var cancellables = Set<AnyCancellable>()

    let dependencyContainer: DependencyContainerProtocol
    let navigationController: UINavigationController
    private(set) var parentCoordinator: CoordinatorProtocol?
    private(set) var childCoordinators = [CoordinatorProtocol]()

    // MARK: - Life Cycle

    init(navigationController: UINavigationController, dependencyContainer: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }

    // MARK: - CoordinatorProtocol

    func start() {
        let viewModel = AdsHomeViewModel(dependencyContainer: dependencyContainer, coordinator: self)
        navigationController.pushViewController(AdsHomeViewController(viewModel: viewModel), animated: false)
    }

    func childDidFinish(_ child: CoordinatorProtocol) {
        if navigationController.presentedViewController === child.navigationController {
            child.navigationController.dismiss(animated: true)
        }

        childCoordinators.removeAll { $0 === child }
    }
}
