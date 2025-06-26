//
//  NewsInspectorApp.swift
//  AsyncImageView.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import SwiftUI

public struct AsyncImageView: View {
    public var url: String?
    private let contetnMode: ContentMode
    
    public init(
        url: String?,
        contentMode: ContentMode = .fit
    ) {
        self.url = url
        self.contetnMode = contentMode
    }
    
    public var body: some View {
        if let urlString = url,
           let imageURL = URL(string: urlString
           ) {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity)
                    .clipped()
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        ProgressView()
                    )
            }
            .padding(.vertical)
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                )
                .frame(minHeight: 100)
                .padding(.vertical)
        }
        
//        if let url = url, let imageURL = URL(string: url) {
//            AsyncImage(url: imageURL) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(
//                        maxWidth: .infinity,
//                        maxHeight: .infinity)
//                    .clipped()
//                    .cornerRadius(12)
//            } placeholder: {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.gray.opacity(0.2))
//                    .overlay(
//                        ProgressView()
//                    )
//            }
//        } else {
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.gray.opacity(0.2))
//                .frame(minHeight: 100)
//                .overlay(
//                    Image(systemName: "photo")
//                        .font(.system(size: 30))
//                        .foregroundColor(.gray)
//                )
//        }
    }
}

#Preview {
    VStack(spacing: 16) {
        AsyncImageView(url: "https://picsum.photos/400/200?random=1")
        
        AsyncImageView(url: nil)
        
        AsyncImageView(url: "invalid-url")
    }
    .padding()
}
