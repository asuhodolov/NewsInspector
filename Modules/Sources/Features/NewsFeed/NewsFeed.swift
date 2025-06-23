//
//  NewsInspectorApp.swift
//  NewsFeed.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI
import NewsFeedShared
import Services
import AppFoundation

public struct NewsFeedView: View {
    @EnvironmentObject private var viewModel: NewsFeedViewModel
    
    public var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading news...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.articles.isEmpty && viewModel.errorMessage == nil {
                    Text("Now news for now")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        List(viewModel.articles) { article in
                            ArticleRowView(
                                article: article,
                                viewedAt: nil,
                                onLikeToggled: { articleId, isLiked in
                                    viewModel.toggleLike(articleId: articleId, isLiked: isLiked)
                                }
                            )
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                            .onAppear {
                                if let lastArticleId = viewModel.articles.last?.id,
                                   article.id == lastArticleId
                                {
                                    viewModel.userDidScrollToBottom()
                                }
                            }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            viewModel.userDidPullToRefresh()
                        }
                        
                        if viewModel.isLoadingNextPage {
                            ProgressView()
                                .padding(.vertical)
                        }
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                }
                
                if viewModel.errorMessage != nil {
                    VStack {
                        Text("Could not load articles")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Try again") {
                            viewModel.userDidPressReload()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Newsfeed")
            .onAppear() {
                viewModel.onAppear()
            }
        }
    }
}

#if DEBUG

final class LikeServiceMock: LikeServiceProtocol {
    func toggleLike(for articleId: Int, isLiked: Bool) async throws {}
}

final class LikesRepositoryMock<Resource: Codable>: ResourceStorable {
    func save(resource: Set<Int>?, resourceId: String) throws {}
    func load(resourceId: String) -> Set<Int>? { nil }
}

final class PreviewNewsFeedInjection: NewsFeedModuleInjectionProtocol {
    private static let webApiManager = WebAPIManager()
    let newsProvider: any NewsProviderProtocol = NewsProviderStub()
    let likeService: any LikeServiceProtocol = LikeServiceMock()
    var likesRepository: any ResourceStorable<Set<Int>> = LikesRepositoryMock<Set<Int>>()
}

#endif

#Preview {
    ModuleProvider().makeNewsFeedModule(injection: PreviewNewsFeedInjection())
}
