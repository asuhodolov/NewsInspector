//
//  OnboardingModuleInjection.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import NewsFeedShared
import Services
import OnboardingShared
import SwiftUI

struct OnboardingModuleInjection: OnboardingModuleInjectionProtocol {
    var newsFeedPresenter: NewsFeedPresenter {
        appCoordinator
    }
    
    private let appCoordinator: AppCoordinatorProtocol
    
    init(appCoordinator: AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }
}
