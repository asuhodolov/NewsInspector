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
    var newsFeedBuilder: () -> any View
    
    private let appCoordinator: AppCoordinatorProtocol
    
    init(
        appCoordinator: AppCoordinatorProtocol,
        newsFeedBuilder: @escaping () -> any View
    ) {
        self.appCoordinator = appCoordinator
        self.newsFeedBuilder = newsFeedBuilder
    }
}
