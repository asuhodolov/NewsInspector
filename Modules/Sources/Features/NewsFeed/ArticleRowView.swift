//
//  ArticleRowView.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI
import Models
import CommonUI

struct ArticleRowView: View {
    let article: NewsFeedViewModel.ArticleModel
    let onLikeToggled: (Int, Bool) -> Void
    let viewedAt: Date?
    let dateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    
    init(
        article: NewsFeedViewModel.ArticleModel,
        viewedAt: Date?,
        onLikeToggled: @escaping (Int, Bool) -> Void
    ) {
        self.article = article
        self.viewedAt = viewedAt
        self.onLikeToggled = onLikeToggled
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GeometryReader { geometry in
                AsyncImageView(
                    url: article.imageUrlString,
                    width: geometry.size.width,
                    height: 180
                )
            }
            .frame(height: 180)
            
            HStack {
                if let text = article.text, !text.isEmpty {
                    Text(text)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                }
                
                Spacer()
                
                Button(action: {
                    let newState = !(article.isLiked ?? false)
                    onLikeToggled(article.id, newState)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: (article.isLiked ?? false) ? "heart.fill" : "heart")
                            .foregroundColor((article.isLiked ?? false) ? .red : .gray)
                            .font(.system(size: 18))
                    }
                }
                .buttonStyle(.plain)
            }
            
            if let viewedAt {
                HStack {
                    Text("Viewed " + dateFormatter.localizedString(for: viewedAt, relativeTo: Date()))
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        ArticleRowView(
            article: NewsFeedViewModel.ArticleModel(
                article:
                    Article(
                        id: 1,
                        imageUrlString: "https://picsum.photos/400/200?random=1",
                        text: "Atricle with details",
                        isLiked: false),
                isLiked: nil),
            viewedAt: Bool.random() ? Date.now : nil,
            onLikeToggled: { _, _ in }
        )
        
        ArticleRowView(
            article: NewsFeedViewModel.ArticleModel(
                article:
                    Article(
                        id: 2,
                        imageUrlString: "https://picsum.photos/400/200?random=2",
                        text: "This is liked This is liked This is liked This is liked",
                        isLiked: true),
                isLiked: nil),
            viewedAt: Bool.random() ? Date.now : nil,
            onLikeToggled: { _, _ in }
        )
        
        ArticleRowView(
            article: NewsFeedViewModel.ArticleModel(
                article:
                    Article(
                        id: 3,
                        imageUrlString: nil,
                        text: "There is no image",
                        isLiked: false),
                isLiked: nil),
            viewedAt: Bool.random() ? Date.now : nil,
            onLikeToggled: { _, _ in }
        )
    }
}
