//
//  StoriesCarouselViewModel.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import AppFoundation
import Models
import NewsFeedShared
import Services

@MainActor
final class StoriesCarouselViewModel: ViewModel, ObservableObject {
    struct StoryPreviewModel: Identifiable {
        var id: Int
        var imageUrlString: String?
        var thumbnailUrlString: String?
        var text: String?
        var isLiked: Bool?
        var isViewed: Bool
        
        init(
            article: Story,
            isLiked: Bool?,
            isViewed: Bool = false
        ) {
            self.id = article.id
            self.imageUrlString = article.imageUrlString
            
            //Ideally server should provide thumbnails for the carousel and other previews
            //It is possible to create and cache them in background but it will take up to 1 hour of time
            self.thumbnailUrlString = article.imageUrlString
            self.text = article.text
            if let isLiked {
                self.isLiked = isLiked
            } else {
                self.isLiked = article.isLiked
            }
            self.isViewed = isViewed
        }
    }
    
    private struct Constants {
        static let newsPerPage: Int = 12
    }
    
    @Published var storyPreviewModels: [StoryPreviewModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoadingNextPage: Bool = false
    @Published var showStoryView: Bool = false
    @Published var selectedStory: StoryPreviewModel?
    
    private let newsProvider: NewsProviderProtocol
    private let likeService: LikeServiceProtocol
    private let likesRepository: any ResourceStorable<Set<Int>>
    private let storySeenService: StorySeenServiceProtocol
    private let storySeenStatusesRepository: any ResourceStorable<Set<Int>>
    
    private var newsRetrievedCount = 0
    private var allNewsRetrieved: Bool = false
    
    init(
        newsProvider: NewsProviderProtocol,
        likeService: LikeServiceProtocol,
        likesRepository: any ResourceStorable<Set<Int>>,
        storySeenService: StorySeenServiceProtocol,
        storySeenStatusesRepository: any ResourceStorable<Set<Int>>
    ) {
        self.newsProvider = newsProvider
        self.likeService = likeService
        self.likesRepository = likesRepository
        self.storySeenService = storySeenService
        self.storySeenStatusesRepository = storySeenStatusesRepository
    }
    
    func onAppear() {
        loadStories()
    }
    
//MARK: User actions
    
    func userDidPressReload() {
        loadStories()
    }
    
    func userDidScrollToTheEnd() {
        guard !allNewsRetrieved,
            !isLoadingNextPage
        else {
            return
        }
        
        loadNextNewsPage()
    }
    
    func userDidTapOnStoryTile(previewModel: StoryPreviewModel) {
        selectedStory = previewModel
        showStoryView = true
        markStoryAsSeen(storyId: previewModel.id)
    }
    
    func userDidToggleLike(for storyId: Int) {
        toggleLike(storyId: storyId)
    }
    
//MARK: ViewModel's business logic
    
    private func loadStories() {
        isLoading = true
        errorMessage = nil
        allNewsRetrieved = false
        newsRetrievedCount = 0
        storyPreviewModels = []
        
        Task {
            do {
                let fetchedArticles = try await newsProvider.retrieveNews(
                    offset: 0,
                    limit: Constants.newsPerPage)
                let cachedLikes = self.likesRepository.load(resourceId: AppFoundation.Constants.articleLikesFileName)
                let cachedSeenStatuses = self.storySeenStatusesRepository.load(resourceId: AppFoundation.Constants.storySeenFileName)
                
                let articlesWithCachedLikes = fetchedArticles.map {
                    return StoryPreviewModel(
                        article: $0,
                        isLiked: cachedLikes?.contains($0.id),
                        isViewed: cachedSeenStatuses?.contains($0.id) ?? false) 
                }
                
                await MainActor.run {
                    self.newsRetrievedCount = articlesWithCachedLikes.count
                    self.storyPreviewModels = articlesWithCachedLikes
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func loadNextNewsPage() {
        errorMessage = nil
        isLoadingNextPage = true
        
        Task {
            do {
                let fetchedArticles = try await newsProvider.retrieveNews(
                    offset: newsRetrievedCount,
                    limit: Constants.newsPerPage)
                let articlesWithCachedLikes = fetchedArticles.map {
                    let cachedLikes = self.likesRepository.load(resourceId: AppFoundation.Constants.articleLikesFileName)
                    return StoryPreviewModel(
                        article: $0,
                        isLiked: cachedLikes?.contains($0.id)
                    )
                }
                
                await MainActor.run {
                    self.newsRetrievedCount += fetchedArticles.count
                    self.isLoadingNextPage = false
                    self.storyPreviewModels.append(contentsOf: articlesWithCachedLikes)
                }
            }
        }
    }
    
    private func toggleLike(storyId: Int) {
        guard let index = storyPreviewModels.firstIndex(where: { $0.id == storyId }) else {
            return
        }
        
        var articleModel = storyPreviewModels[index]
        let liked = !(articleModel.isLiked ?? false)
        articleModel.isLiked = liked
        storyPreviewModels[index] = articleModel
        
        if selectedStory?.id == storyId {
            selectedStory = articleModel
        }
        
        Task {
            do {
                try await likeService.toggleLike(
                    for: storyId,
                    isLiked: liked)
            } catch {
                await MainActor.run {
                    if let index = storyPreviewModels.firstIndex(where: { $0.id == storyId }) {
                        var articleModel = storyPreviewModels[index]
                        articleModel.isLiked = !liked
                        storyPreviewModels[index] = articleModel
                        
                        if selectedStory?.id == articleModel.id {
                            selectedStory = articleModel
                        }
                    }
                }
            }
        }
    }
    
    private func markStoryAsSeen(storyId: Int) {
        Task {
            do {
                try await storySeenService.markAsSeen(for: storyId)
            } catch {
                await MainActor.run {
                    if let index = storyPreviewModels.firstIndex(where: { $0.id == storyId }) {
                        var articleModel = storyPreviewModels[index]
                        articleModel.isViewed = false
                        storyPreviewModels[index] = articleModel
                        
                        if selectedStory?.id == articleModel.id {
                            selectedStory = articleModel
                        }
                    }
                }
            }
        }
        
        guard let index = storyPreviewModels.firstIndex(where: { $0.id == storyId }) else {
            return
        }
        
        var articleModel = storyPreviewModels[index]
        articleModel.isViewed = true
        storyPreviewModels[index] = articleModel
    }
}
