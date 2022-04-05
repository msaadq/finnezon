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
    private var allAdItems = [AdItem]()

    enum State {
        case idle
        case loading
        case failed(AdsServiceError)
        case loaded
    }

    @Published var displayedAdItems = [AdItem]()
    @Published var state = State.idle
    @Published var showingFavourites = false

    init(dependencyContainer: DependencyContainerProtocol = PreviewDependencyContainer(), coordinator: HomeCoordinator? = nil) {
        self.dependencyContainer = PreviewDependencyContainer()
        self.coordinator = coordinator

        // Filtering the shown items
        $showingFavourites
            .sink { [weak self] value in
                guard let strongSelf = self else { return }
                if value == true {
                    strongSelf.displayedAdItems = strongSelf.allAdItems.filter { $0.isFavourite }
                } else {
                    strongSelf.displayedAdItems = strongSelf.allAdItems
                }
            }
            .store(in: &cancellables)
    }

    func retrieveAllAds() {
        state = .loading
        dependencyContainer.adsService.loadAllAds()
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.state = .failed(error)
                }
            } receiveValue: { [weak self] adItems in
                self?.allAdItems = adItems
                self?.displayedAdItems = adItems
                self?.state = .loaded
            }
            .store(in: &cancellables)
    }
}
