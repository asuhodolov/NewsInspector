//
//  NewsFeedModuleInjection.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 26/06/2025.
//

import Foundation
import AppFoundation
import NewsFeedShared
import NewsFeed
import Services

struct NewsFeedModuleInjection: NewsFeedModuleInjectionProtocol {
    var newsProvider: NewsProviderProtocol
    var likeService: LikeServiceProtocol
    var likesRepository: any ResourceStorable<Set<Int>>
    var storySeenService: StorySeenServiceProtocol
    var storySeenStatusesRepository: any ResourceStorable<Set<Int>>
    var captureViewModel: CaptureViewModel
    
    private let appCoordinator: AppCoordinatorProtocol
    
    init(
        appCoordinator: AppCoordinatorProtocol,
        captureViewModel: @escaping CaptureViewModel
    ) {
        self.appCoordinator = appCoordinator
        self.captureViewModel = captureViewModel
        newsProvider = appCoordinator.services.newsProvider
        likeService = appCoordinator.services.likeService
        likesRepository = appCoordinator.services.likedArticlesFileRepository
        storySeenService = appCoordinator.services.storySeenService
        storySeenStatusesRepository = appCoordinator.services.storySeenStatusesFileRepository
    }
}
