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
    private var cancellables = Set<AnyCancellable>()

    @Published var adItems = [AdItem]()

    init(dependencyContainer: DependencyContainerProtocol = PreviewDependencyContainer(), coordinator: HomeCoordinator? = nil) {
        self.dependencyContainer = PreviewDependencyContainer()
        self.coordinator = coordinator
    }

    func retrieveAllAds() {
        dependencyContainer.adsService.loadAllAds()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { adItems in
                self.adItems = adItems
            }
            .store(in: &cancellables)
    }
}
