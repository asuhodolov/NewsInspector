//
//  NewsFeedModuleProvider.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import Architecture
import SwiftUI
import Services

extension ModuleProvider {
    public class func makeNewsFeed(injection: NewsFeedModuleInjectionProtocol) -> some View {
        return iTunesSearchModuleAssembler.makeModule(injection: injection)
    }
}

@MainActor
public protocol NewsFeedModuleInjectionProtocol {
    var webApiManager: WebAPIManagerProtocol { get }
    var onboardingRouter: OnboardingRouterProtocol { get }
}
