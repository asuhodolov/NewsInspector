//
//  StorySeenService.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 26/06/2025.
//

import Foundation
import Services
import AppFoundation

@MainActor
public final class StorySeenService: StorySeenServiceProtocol {
    private let storySeenStatusesRepository: any ResourceStorable<Set<Int>>
    
    public init(storySeenStatusesRepository: any ResourceStorable<Set<Int>>) {
        self.storySeenStatusesRepository = storySeenStatusesRepository
    }
    
    public func markAsSeen(for articleId: Int) async throws {
        var seenStoriesIds = storySeenStatusesRepository.load(resourceId: AppFoundation.Constants.storySeenFileName) ?? Set<Int>()
        seenStoriesIds.insert(articleId)
        try storySeenStatusesRepository.save(
            resource: seenStoriesIds, resourceId: AppFoundation.Constants.storySeenFileName)
    }
}

final class StorySeenServiceStub: StorySeenServiceProtocol {
    public func markAsSeen(for articleId: Int) async throws {}
}
