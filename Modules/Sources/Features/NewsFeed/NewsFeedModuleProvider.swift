//
//  NewsFeedModuleProvider.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import NewsFeedShared
import AppFoundation
import Services
import SwiftUI

extension ModuleProvider: NewsFeedModuleProviderProtocol {
    public func makeNewsFeedModule(injection: NewsFeedModuleInjectionProtocol) -> any View {
        NewsFeedView()
            .environmentObject(
                NewsFeedViewModel(
                    newsProvider: injection.newsProvider,
                    likeService: injection.likeService,
                    likesRepository: injection.likesRepository))
    }
}
