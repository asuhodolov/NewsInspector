//
//  NewsFeedModuleProvider.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import AppFoundation
import OnboardingShared
import SwiftUI

extension ModuleProvider: OnboardingModuleProviderProtocol {
    public func makeOnboardingModule(injection: any OnboardingModuleInjectionProtocol) -> any View {
        AnyView(Onboarding(newsFeedBuilder: injection.newsFeedBuilder))
    }
}
