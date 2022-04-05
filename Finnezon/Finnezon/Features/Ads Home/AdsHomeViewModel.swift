//
//  AdsHomeViewModel.swift
//  Finnezon
//
//  Created by Saad Qureshi on 05/04/2022.
//

import Combine

class AdsHomeViewModel: ObservableObject {
    var dependencyContainer: DependencyContainerProtocol
    private var coordinator: HomeCoordinator?
    private var cancellables = Set<AnyCancellable>()

    enum State {
        case idle
        case loading
        case failed(AdsServiceError)
        case loaded
    }

    @Published var adItems = [AdItem]()
    @Published var state = State.idle

    init(dependencyContainer: DependencyContainerProtocol = PreviewDependencyContainer(), coordinator: HomeCoordinator? = nil) {
        self.dependencyContainer = PreviewDependencyContainer()
        self.coordinator = coordinator
    }

    func retrieveAllAds() {
        state = .loading
        dependencyContainer.adsService.loadAllAds()
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.state = .failed(error)
                }
            } receiveValue: { [weak self] adItems in
                self?.adItems = adItems
                self?.state = .loaded
            }
            .store(in: &cancellables)
    }
}
