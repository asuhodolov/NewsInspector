//
//  NewsFeedViewModel.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 26/06/2025.
//

import Foundation
import SwiftUI
import AppFoundation
import NewsFeedShared

@MainActor
final class NewsFeedViewModel: ViewModel, ObservableObject {
    @Published
    var storiesCarouselViewModel: StoriesCarouselViewModel?
    
    private let injection: NewsFeedModuleInjectionProtocol
    
    init(injection: NewsFeedModuleInjectionProtocol) {
        self.injection = injection
    }
    
    func onAppear() {
        storiesCarouselViewModel = StoriesCarouselViewModel(
            newsProvider: injection.newsProvider,
            likeService: injection.likeService,
            likesRepository: injection.likesRepository,
            storySeenService: injection.storySeenService,
            storySeenStatusesRepository: injection.storySeenStatusesRepository)
    }
}
