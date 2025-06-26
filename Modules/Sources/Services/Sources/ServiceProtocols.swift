//
//  ServiceProtocols.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 26/06/2025.
//

import Foundation
import Models

public protocol LikeServiceProtocol {
    func toggleLike(for articleId: Int, isLiked: Bool) async throws
}

public protocol StorySeenServiceProtocol {
    func markAsSeen(for articleId: Int) async throws
}

public protocol NewsProviderProtocol {
    func retrieveNews(offset: Int, limit: Int) async throws -> [Story]
}
