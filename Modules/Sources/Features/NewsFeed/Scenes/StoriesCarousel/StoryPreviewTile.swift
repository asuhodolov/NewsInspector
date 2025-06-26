//
//  StoryPreviewTile.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 26/06/2025.
//

import Foundation
import SwiftUI

struct StoryPreviewTile: View {
    private struct Constants {
        static let imageWidth = 70.0
    }
    
    let model: StoriesCarouselViewModel.StoryPreviewModel

    var borderColor: Color {
        model.isViewed ? .gray.opacity(0.5) : .green
    }

    var body: some View {
        ZStack {
            if let urlString = model.thumbnailUrlString,
                let url = URL(string: urlString
            ) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: Constants.imageWidth,
                                height: Constants.imageWidth)
                            .clipShape(Circle())
                    case .failure(_):
                        placeholder
                    case .empty:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(
            width: 76,
            height: 76)
        .background(
            Circle()
                .stroke(borderColor, lineWidth: 2)
        )
    }

    var placeholder: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(
                width: Constants.imageWidth,
                height: Constants.imageWidth)
            .overlay(
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white.opacity(0.6))
                    .padding(20)
            )
    }
}


#Preview {
    HStack(spacing: 16) {
        StoryPreviewTile(model: StoriesCarouselViewModel.StoryPreviewModel(
            article: .init(
                id: 1,
                imageUrlString: "https://picsum.photos/400/200?random=2",
                text: "With Image",
                isLiked: true),
            isLiked: false))

        StoryPreviewTile(model: StoriesCarouselViewModel.StoryPreviewModel(
            article: .init(
                id: 2,
                imageUrlString: nil,
                text: "No Image",
                isLiked: false),
            isLiked: false,
            isViewed: true))
    }
    .padding()   
}
