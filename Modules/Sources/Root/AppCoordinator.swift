//
//  NewsInspectorApp.swift
//  AppCoordinator.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import Services
import NewsFeed
import NewsFeedShared
import SwiftUI
import AppFoundation
import Onboarding

@MainActor
public protocol AppCoordinatorProtocol {
    var services: Services { get }
}

@MainActor
public final class AppCoordinator: AppCoordinatorProtocol {
    public let services = Services()
    private let moduleProvider = ModuleProvider()
    
    public func makeRootView() -> any View {
        moduleProvider.makeOnboardingModule(
            injection: OnboardingModuleInjection(
                appCoordinator: self,
                newsFeedBuilder: {
                    self.moduleProvider.makeNewsFeedModule(injection: NewsFeedModuleInjection(appCoordinator: self))
                }))
    }
    
    public init() {}
}

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
}
