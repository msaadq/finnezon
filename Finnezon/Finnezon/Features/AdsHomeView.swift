//
//  AdsHomeView.swift
//  Finnezon
//
//  Created by Saad Qureshi on 05/04/2022.
//

import SwiftUI

struct AdsHomeView: View {
    @ObservedObject var viewModel: AdsHomeViewModel

    var body: some View {
        Text("Hello")
            .task {
                viewModel.retrieveAllAds()
            }
    }
}

// UIHostingController Implementation
class AdsHomeViewController: UIHostingController<AdsHomeView> {
    var viewModel: AdsHomeViewModel

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do all changes related to NavigationItems
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
