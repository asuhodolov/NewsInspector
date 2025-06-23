//
//  NewsInspectorApp.swift
//  AsyncImageView.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import SwiftUI

public struct AsyncImageView: View {
    public var url: String?
    public var width: CGFloat
    public var height: CGFloat
    
    public init(url: String?, width: CGFloat, height: CGFloat) {
        self.url = url
        self.width = width
        self.height = height
    }
    
    public var body: some View {
        Group {
            if let url = url, let imageURL = URL(string: url) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipped()
                        .cornerRadius(12)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: width, height: height)
                        .overlay(
                            ProgressView()
                        )
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: width, height: height)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    )
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        AsyncImageView(
            url: "https://picsum.photos/400/200?random=1",
            width: 350,
            height: 180
        )
        
        AsyncImageView(
            url: nil,
            width: 350,
            height: 180
        )
        
        AsyncImageView(
            url: "invalid-url",
            width: 350,
            height: 180
        )
    }
    .padding()
}
