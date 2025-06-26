//
//  NewsFeedView.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 26/06/2025.
//

import Foundation
import SwiftUI
import AppFoundation

public struct NewsFeedView: View {
    @EnvironmentObject private var viewModel: NewsFeedViewModel
    
    public var body: some View {
        NavigationStack {
            VStack {
                if let storiesViewModel = viewModel.storiesCarouselViewModel {
                    StoriesCarouselView()
                        .environmentObject(storiesViewModel)
                        .padding(.top)
                }
                
                Spacer()
            }
            .navigationTitle(Text("Feed"))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}
