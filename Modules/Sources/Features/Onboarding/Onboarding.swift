//
//  NewsInspectorApp.swift
//  Onboarding.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI

public struct Onboarding: View {
    @State private var showNewsFeed = false
    private let newsFeedBuilder: () -> any View
    
    public init(newsFeedBuilder: @escaping () -> any View) {
        self.newsFeedBuilder = newsFeedBuilder
    }
    
    public var body: some View {
        VStack {
            Text("This screen is added to demonstrate how to present two views from different SPM modules from each other.")
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Go To NewsFeed") {
                showNewsFeed = true
            }
            .buttonStyle(.borderedProminent)
        }
        .fullScreenCover(isPresented: $showNewsFeed) {
            AnyView(newsFeedBuilder())
        }
    }
}
