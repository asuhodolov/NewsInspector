//
//  Services.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 26/06/2025.
//

import Foundation
import Services
import NewsFeed

@MainActor
public final class Services {
    lazy var webApiManager: some WebAPIManagerProtocol = {
        WebAPIManager()
    }()
    
    lazy var newsProvider: some NewsProviderProtocol = {
        NewsDiskProvider(likesRepository: self.likedArticlesFileRepository)
    }()
    
    lazy var likeService: some LikeServiceProtocol = {
        LikeService(likesRepository: self.likedArticlesFileRepository)
    }()
    
    lazy var likedArticlesFileRepository: some ResourceStorable<Set<Int>> = {
        JSONFileRepository()
    }()
    
    lazy var storySeenService: some StorySeenServiceProtocol = {
        StorySeenService(storySeenStatusesRepository: self.storySeenStatusesFileRepository)
    }()
    
    lazy var storySeenStatusesFileRepository: some ResourceStorable<Set<Int>> = {
        JSONFileRepository()
    }()
}
