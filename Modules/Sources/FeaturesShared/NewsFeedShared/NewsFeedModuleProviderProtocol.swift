//
//  NewsInspectorApp.swift
//  StoriesCarouselModuleProvider.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI
import Services
import AppFoundation

@MainActor
public protocol NewsFeedModuleInjectionProtocol {
    var newsProvider: NewsProviderProtocol { get }
    var likeService: LikeServiceProtocol { get }
    var likesRepository: any ResourceStorable<Set<Int>> { get }
    var storySeenService: StorySeenServiceProtocol { get }
    var storySeenStatusesRepository: any ResourceStorable<Set<Int>> { get }
    var captureViewModel: CaptureViewModel { get }
}

@MainActor
public protocol OnboardingPresenter {
    func presentOnboarding()
}
