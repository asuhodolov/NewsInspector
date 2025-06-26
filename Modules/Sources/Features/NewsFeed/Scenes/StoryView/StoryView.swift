//
//  StoryView.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI
import Models
import CommonUI

struct StoryView: View {
    let previewModel: StoriesCarouselViewModel.StoryPreviewModel
    let onLikeToggled: (_ previewModel: StoriesCarouselViewModel.StoryPreviewModel) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    init(
        previewModel: StoriesCarouselViewModel.StoryPreviewModel,
        onLikeToggled: @escaping (_ previewModel: StoriesCarouselViewModel.StoryPreviewModel) -> Void
    ) {
        self.previewModel = previewModel
        self.onLikeToggled = onLikeToggled
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(edges: .all)
            
            VStack {
                AsyncImageView(
                    url: previewModel.imageUrlString,
                    contentMode: .fit
                )
                .onTapGesture(count: 2) {
                    onLikeToggled(previewModel)
                }
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    if let text = previewModel.text, !text.isEmpty {
                        Text(text)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(10)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        onLikeToggled(previewModel)
                    }) {
                        Image(systemName: (previewModel.isLiked ?? false) ? "heart.fill" : "heart")
                            .foregroundColor((previewModel.isLiked ?? false) ? .red : .gray)
                            .font(.system(size: 18))
                    }
                    .buttonStyle(.plain)
                    .padding()
                }
                .frame(minHeight: 30)
                .background(Color.black.opacity(0.3))
            }
        }
    }
}

#Preview {
    StoryView(
        previewModel: StoriesCarouselViewModel.StoryPreviewModel(
            article:
                Story(
                    id: 2,
                    imageUrlString: "https://picsum.photos/400/200?random=2",
                    text: "This is liked This is liked This is liked This is liked",
                    isLiked: true),
            isLiked: true),
        onLikeToggled: {_ in })
}
