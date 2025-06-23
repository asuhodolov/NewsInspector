//
//  NewsFeedModuleInjection.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import NewsFeedShared
import Services

struct NewsFeedModuleInjection: NewsFeedModuleInjectionProtocol {
    var newsProvider: NewsProviderProtocol
    var likeService: LikeServiceProtocol
    var likesRepository: any ResourceStorable<Set<Int>>
    
    private let appCoordinator: AppCoordinatorProtocol
    
    init(appCoordinator: AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
        newsProvider = appCoordinator.services.newsProvider
        likeService = appCoordinator.services.likeService
        likesRepository = appCoordinator.services.likedArticlesFileRepository
    }
}
