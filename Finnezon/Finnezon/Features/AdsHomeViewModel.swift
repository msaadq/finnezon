//
//  AdsHomeViewModel.swift
//  Finnezon
//
//  Created by Saad Qureshi on 05/04/2022.
//

import Combine

class AdsHomeViewModel: ObservableObject {
    private var dependencyContainer: DependencyContainerProtocol
    private var coordinator: HomeCoordinator?

    init(dependencyContainer: DependencyContainerProtocol = PreviewDependencyContainer(), coordinator: HomeCoordinator? = nil) {
        self.dependencyContainer = dependencyContainer
        self.coordinator = coordinator
    }
}
