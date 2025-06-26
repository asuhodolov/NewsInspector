//
//  OnboardingModuleProvider.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import AppFoundation
import OnboardingShared
import SwiftUI

extension ModuleProvider {
    public static func makeOnboardingModule(injection: any OnboardingModuleInjectionProtocol) -> any View {
        Onboarding(newsFeedPresenter: injection.newsFeedPresenter)
    }
}
