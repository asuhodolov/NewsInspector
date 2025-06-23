//
//  NewsInspectorApp.swift
//  NewsFeedModuleProvider.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI
import Architecture
import Services
import Models

@MainActor
public protocol NewsFeedModuleProviderProtocol {
    func makeNewsFeedModule(injection: NewsFeedModuleInjectionProtocol) -> any View
}

public protocol LikeServiceProtocol {
    func toggleLike(for articleId: Int, isLiked: Bool) async throws
}

public protocol NewsProviderProtocol {
    func retrieveNews(offset: Int, limit: Int) async throws -> [Article]
}

@MainActor
public protocol NewsFeedModuleInjectionProtocol {
    var newsProvider: NewsProviderProtocol { get }
    var likeService: LikeServiceProtocol { get }
    var likesRepository: any ResourceStorable<Set<Int>> { get }
}
