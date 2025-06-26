//
//  NewsInspectorApp.swift
//  AppCoordinator.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI
import AppFoundation
import Onboarding
import OnboardingShared
import NewsFeed
import NewsFeedShared

@MainActor
protocol AppCoordinatorProtocol: NewsFeedPresenter, OnboardingPresenter {
    var services: Services { get }
}

@MainActor
public final class AppCoordinator: AppCoordinatorProtocol, ObservableObject {
    let services = Services()

    @Published
    public var rootView: AnyView?
    
    private var activeViewModel: (any ViewModel)?
        
    public init() {
        presentOnboarding()
    }
}

//MARK: - NewsFeedPresenter

extension AppCoordinator: NewsFeedPresenter {
    public func presentNewsFeed() {
        rootView = AnyView(ModuleProvider.makeNewsFeedModule(
            injection: NewsFeedModuleInjection(
                appCoordinator: self,
                captureViewModel: {
                    self.activeViewModel = $0
                })))
    }
}

//MARK: - OnboardingPresenter

extension AppCoordinator: OnboardingPresenter {
    public func presentOnboarding() {
        rootView = AnyView(ModuleProvider.makeOnboardingModule(injection: OnboardingModuleInjection(appCoordinator: self)))
    }
}
