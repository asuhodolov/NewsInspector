//
//  NewsInspectorApp.swift
//  Onboarding.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI
import OnboardingShared

public struct Onboarding: View {
    private let newsFeedPresenter: NewsFeedPresenter
    
    public init(newsFeedPresenter: NewsFeedPresenter) {
        self.newsFeedPresenter = newsFeedPresenter
    }
    
    public var body: some View {
        VStack {
            Text("This screen is added to demonstrate how to present two views from different SPM modules from each other.")
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding()
            
                Button("Go To NewsFeed") {
                    newsFeedPresenter.presentNewsFeed()
                }
                .buttonStyle(.borderedProminent)
            }
    }
}
