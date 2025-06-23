//
//  NewsProvider.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import Models
import Services
import NewsFeedShared
import AppFoundation

enum NewsError: Error {
    case decodingError
}

//MARK: - Disk storage

private func prepareDiskDataForPagination(
    articles: [Article],
    offset: Int,
    limit: Int
) -> [Article] {
    guard articles.isEmpty == false else {
        return []
    }
    
    var preparedArticles: [Article] = []
    for i in offset..<limit+offset {
        let indexInArray = i % articles.count
        var article = articles[indexInArray]
        article.id = i
        preparedArticles.append(article)
    }
    return preparedArticles
}

@MainActor
public final class NewsDiskProvider: NewsProviderProtocol {
    private struct ArticlesResponseData: Decodable {
        let articles: [Article]
        
        enum CodingKeys: String, CodingKey {
            case articles = "articles"
        }
    }
    
    private let likesRepository: any ResourceStorable<Set<Int>>
    
    public init(likesRepository: any ResourceStorable<Set<Int>>) {
        self.likesRepository = likesRepository
    }
    
    public func retrieveNews(offset: Int, limit: Int) async throws -> [Article] {
        guard let url = Bundle.module.url(forResource: "articles", withExtension: "json") else {
            throw NewsError.decodingError
        }

        do {
            let data = try Data(contentsOf: url)
            let newsData: ArticlesResponseData = try NewsRequestDataParser().parse(data: data)
            
            let articlesPreparedForPagination = prepareDiskDataForPagination(
                articles: newsData.articles,
                offset: offset,
                limit: limit)
            
            let likedArticlesIds = likesRepository.load(resourceId: AppFoundation.Constants.articleLikesFileName)
            let articlesWithLikes = articlesPreparedForPagination.map {
                var article = $0
                article.isLiked = likedArticlesIds?.contains($0.id)
                return article
            }
            
            try await Task.sleep(for: .seconds(1))
            return articlesWithLikes
        } catch {
            throw NewsError.decodingError
        }
    }
}

//MARK: - Web server storage

//NewsWebProvider is present just for a demo purpose
public final class NewsWebProvider: NewsProviderProtocol {
    private struct ArticlesResponseData: Decodable {
        let articles: [Article]
        
        enum CodingKeys: String, CodingKey {
            case articles = "articles"
        }
    }
    
    let webApiManager: WebAPIManagerProtocol
    
    public init(webApiManager: WebAPIManagerProtocol) {
        self.webApiManager = webApiManager
    }
    
    public func retrieveNews(offset: Int, limit: Int) async throws -> [Article] {
        let newsData: ArticlesResponseData = try await webApiManager.perform(
            NewsRequest.retrieveNews(offset: offset, limit: limit),
            parser: NewsRequestDataParser())
    
        return newsData.articles
    }
}

private class NewsRequestDataParser: DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}

//MARK: - News provider stab

final class NewsProviderStub: NewsProviderProtocol {
    func retrieveNews(offset: Int, limit: Int) async throws -> [Article] {
        try await Task.sleep(for: .seconds(1))
        return [
            Article(
                id: 1,
                imageUrlString: "https://picsum.photos/400/200?random=1",
                text: "Text1",
                isLiked: false
            ),
            Article(
                id: 2,
                imageUrlString: "https://picsum.photos/400/200?random=2",
                text: "Text2",
                isLiked: true
            ),
            Article(
                id: 3,
                imageUrlString: "https://picsum.photos/400/200?random=3",
                text: "Text3",
                isLiked: false
            ),
            Article(
                id: 4,
                imageUrlString: "https://picsum.photos/400/200?random=4",
                text: "Text4 Long Text4 Long Text4 Long Text4 Long Text4 Long Text4 Long Text4 Long Text4 Long Text4 Long Text4 Long",
                isLiked: false
            ),
            Article(
                id: 5,
                imageUrlString: "https://picsum.photos/400/200?random=5",
                text: "Text5",
                isLiked: true
            ),
        ]
    }
}
