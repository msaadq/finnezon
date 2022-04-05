//
//  AdItemView.swift
//  Finnezon
//
//  Created by Saad Qureshi on 05/04/2022.
//

import SwiftUI

struct AdItemView: View {
    @ObservedObject var viewModel: AdItemViewModel

    private let accentColor = Color.cyan

    init(viewModel: AdItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
    }

    @ViewBuilder
    var content: some View {
        VStack {
            ZStack(alignment: .bottom) {
                AsyncImage(url: viewModel.photoURL) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .clipped()
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .foregroundColor(accentColor)
                            .aspectRatio(contentMode: .fit)
                            .padding(30)
                            .frame(height: 180)
                    } else {
                        ProgressView()
                            .frame(height: 180)
                    }
                }

                LinearGradient(gradient: Gradient(colors: [.black.opacity(0), .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    .frame(height: 50)

                HStack(alignment: .center) {
                    Text(viewModel.adTypeLabel)
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(accentColor)
                        .cornerRadius(20)
                    Spacer()
                    Text(viewModel.priceLabel)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 8)
            }

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.titleLabel ?? "")
                        .lineLimit(1)
                        .font(.title3)
                    HStack {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(accentColor)
                        Text(viewModel.LocationLabel ?? "")
                            .font(.footnote)
                    }
                }
                Spacer()

                Button {
                    viewModel.toggleFavouriteStatus()
                } label: {
                    Image(systemName: viewModel.isFavourite ? "heart.fill" : "heart")
                        .resizable()
                        .foregroundColor(accentColor)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 0.1)
        )
    }
}

struct AdItemView_Previews: PreviewProvider {
    static var previews: some View {
        AdItemView(viewModel: AdItemViewModel(adItem: AdItem(id: "12243", adType: .b2B, itemDescription: "Yolo", location: "Yolo", price: AdItem.Price(value: 300, total: 350), image: AdItem.Image(url: "https://images.finncdn.no/dynamic/480x360c/2022/3/vertical-0/21/9/252/099/759_626536615.jpg", type: .general) , score: 200), dependencyContainer: PreviewDependencyContainer()))
    }
}
