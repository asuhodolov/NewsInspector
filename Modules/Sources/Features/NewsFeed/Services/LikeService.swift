//
//  LikeService.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import AppFoundation
import Services
import NewsFeedShared

enum LikeError: Error {
    case infraError
    case networkError
    case invalidData
}

@MainActor
public final class LikeService: LikeServiceProtocol {
    private let likesRepository: any ResourceStorable<Set<Int>>
    
    public init(likesRepository: any ResourceStorable<Set<Int>>) {
        self.likesRepository = likesRepository
    }
    
    public func toggleLike(for articleId: Int, isLiked: Bool) async throws {
        var likedIds = likesRepository.load(resourceId: AppFoundation.Constants.articleLikesFileName) ?? Set<Int>()
        likedIds.insert(articleId)
        try likesRepository.save(
            resource: likedIds,
            resourceId: AppFoundation.Constants.articleLikesFileName)
    }
}

final class LikeServiceStub: LikeServiceProtocol {
    func toggleLike(for articleId: Int, isLiked: Bool) async throws {}
} 
