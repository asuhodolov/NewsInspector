//
//  NewsFeedViewModel.swift
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
final class NewsFeedViewModel: ObservableObject {
    struct ArticleModel: Identifiable {
        public var id: Int
        public var imageUrlString: String?
        public var text: String?
        public var isLiked: Bool?
        
        init(
            article: Article,
            isLiked: Bool?
        ) {
            self.id = article.id
            self.imageUrlString = article.imageUrlString
            self.text = article.text
            if let isLiked {
                self.isLiked = isLiked
            } else {
                self.isLiked = article.isLiked
            }
        }
    }
    
    private struct Constants {
        static let newsPerPage: Int = 12
    }
    
    @Published var articles: [ArticleModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoadingNextPage: Bool = false
    
    private let newsProvider: NewsProviderProtocol
    private let likeService: LikeServiceProtocol
    private let likesRepository: any ResourceStorable<Set<Int>>
    
    private var newsRetrievedCount = 0
    private var allNewsRetrieved: Bool = false
    
    init(
        newsProvider: NewsProviderProtocol,
        likeService: LikeServiceProtocol,
        likesRepository: any ResourceStorable<Set<Int>>
    ) {
        self.newsProvider = newsProvider
        self.likeService = likeService
        self.likesRepository = likesRepository
    }
    
    func onAppear() {
        loadNews()
    }
    
//MARK: User actions
    
    func userDidPullToRefresh() {
        loadNews()
    }
    
    func userDidPressReload() {
        loadNews()
    }
    
    func userDidScrollToBottom() {
        guard !allNewsRetrieved,
            !isLoadingNextPage
        else {
            return
        }
        
        loadNextNewsPage()
    }
    
    func articleIsDisplayd(id: Int) {
        //TODO: Implement "isViewed" logic. Should be similar to the like service. Possibly with debounce logic and sending batches of updates
    }
    
//MARK: ViewModel's business logic
    
    private func loadNews() {
        isLoading = true
        errorMessage = nil
        allNewsRetrieved = false
        newsRetrievedCount = 0
        articles = []
        
        Task {
            do {
                let fetchedArticles = try await newsProvider.retrieveNews(
                    offset: 0,
                    limit: Constants.newsPerPage)
                let articlesWithCachedLikes = fetchedArticles.map {
                    let cachedLikes = self.likesRepository.load(resourceId: AppFoundation.Constants.articleLikesFileName)
                    return ArticleModel(
                        article: $0,
                        isLiked: cachedLikes?.contains($0.id)
                    )
                }
                
                await MainActor.run {
                    self.newsRetrievedCount = articlesWithCachedLikes.count
                    self.articles = articlesWithCachedLikes
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
                    return ArticleModel(
                        article: $0,
                        isLiked: cachedLikes?.contains($0.id)
                    )
                }
                
                await MainActor.run {
                    self.newsRetrievedCount += fetchedArticles.count
                    self.isLoadingNextPage = false
                    self.articles.append(contentsOf: articlesWithCachedLikes)
                }
            }
        }
    }
    
    func toggleLike(
        articleId: Int,
        isLiked: Bool
    ) {
        if let index = articles.firstIndex(where: { $0.id == articleId }) {
            var articleModel = articles[index]
            articleModel.isLiked = isLiked
            articles[index] = articleModel
        }
        
        Task {
            do {
                try await likeService.toggleLike(
                    for: articleId,
                    isLiked: isLiked)
            } catch {
                await MainActor.run {
                    if let index = articles.firstIndex(where: { $0.id == articleId }) {
                        var articleModel = articles[index]
                        articleModel.isLiked = !isLiked
                        articles[index] = articleModel
                    }
                }
            }
        }
    }
}
