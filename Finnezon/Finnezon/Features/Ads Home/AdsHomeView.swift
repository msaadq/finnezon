//
//  AdsHomeView.swift
//  Finnezon
//
//  Created by Saad Qureshi on 05/04/2022.
//

import SwiftUI

struct AdsHomeView: View {
    @ObservedObject var viewModel: AdsHomeViewModel

    // MARK: - Body

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Text("Idle")
            case .loading:
                ProgressView("Loading Ads...")
                    .scaleEffect(2)
                    .font(.caption)
            case .failed(let error):
                showErrorView(error: error)
            case .loaded:
                content
            }
        }
        .task { viewModel.retrieveAllAds() }
    }

    // MARK: - UI Elements

    @ViewBuilder
    var content: some View {
        List {
            ForEach(viewModel.adItems) { item in
                AdItemView(viewModel: .init(adItem: item, dependencyContainer: viewModel.dependencyContainer))
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.grouped)
    }

    @ViewBuilder
    func showErrorView(error: AdsServiceError) -> some View {
        VStack(spacing: 40) {
            switch error {
            case .noAds:
                Text("No Ads Found!")
                    .font(.title)
            case .dataFetcherError(let error):
                VStack (spacing: 20) {
                    Text("Error")
                        .font(.title)
                    Text(error.localizedDescription)
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                }
            }

            Button {
                viewModel.retrieveAllAds()
            } label: {
                Text("Try Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
        }
        .padding(.horizontal, 40)
    }
}

// UIHostingController Implementation
class AdsHomeViewController: UIHostingController<AdsHomeView> {
    var viewModel: AdsHomeViewModel

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Ads Home"
    }

    init(viewModel: AdsHomeViewModel) {
        self.viewModel = viewModel
        super.init(rootView: AdsHomeView(viewModel: viewModel))
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


struct AdsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AdsHomeView(viewModel: AdsHomeViewModel())
    }
}
