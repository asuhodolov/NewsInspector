//
//  NewsInspectorApp.swift
//  StoriesCarousel.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI
import NewsFeedShared
import Services
import AppFoundation

public struct StoriesCarouselView: View {
    @EnvironmentObject private var viewModel: StoriesCarouselViewModel
    
    public var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading stories...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.storyPreviewModels.isEmpty && viewModel.errorMessage == nil {
                Text("No stories for now")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(viewModel.storyPreviewModels) { previewModel in
                                StoryPreviewTile(model: previewModel)
                                    .onAppear {
                                        if let lastArticleId = viewModel.storyPreviewModels.last?.id,
                                           previewModel.id == lastArticleId
                                        {
                                            viewModel.userDidScrollToTheEnd()
                                        }
                                    }
                                    .onTapGesture {
                                        viewModel.userDidTapOnStoryTile(previewModel: previewModel)
                                    }
                            }
                            
                            if viewModel.isLoadingNextPage {
                                ProgressView()
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.leading, 16)
                    }
                    .frame(height: 84)
                }
            }
            
            if viewModel.errorMessage != nil {
                VStack {
                    Button("Reload stories") {
                        viewModel.userDidPressReload()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            viewModel.onAppear()
        }
        .fullScreenCover(isPresented: $viewModel.showStoryView) {
            if let storyPreviewModel = viewModel.selectedStory {
                StoryView(
                    previewModel: storyPreviewModel,
                    onLikeToggled: { [weak viewModel] previewModel in
                        viewModel?.userDidToggleLike(for: previewModel.id)
                    })
            }
        }
    }
}

#if DEBUG

final class LikeServiceMock: LikeServiceProtocol {
    func toggleLike(for articleId: Int, isLiked: Bool) async throws {}
}

final class FileRepositoryMock<Resource: Codable>: ResourceStorable {
    func save(resource: Set<Int>?, resourceId: String) throws {}
    func load(resourceId: String) -> Set<Int>? { nil }
}

@MainActor
private let previewViewModel = StoriesCarouselViewModel(
    newsProvider: NewsProviderStub(),
    likeService: LikeServiceMock(),
    likesRepository: FileRepositoryMock<Set<Int>>(),
    storySeenService: StorySeenServiceStub(),
    storySeenStatusesRepository: FileRepositoryMock<Set<Int>>())

#endif

#Preview {
    StoriesCarouselView()
        .environmentObject(previewViewModel)
}
