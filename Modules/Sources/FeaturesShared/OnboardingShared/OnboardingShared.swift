//
//  NewsInspectorApp.swift
//  OnboardingShared.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI

@MainActor
public protocol OnboardingModuleProviderProtocol {
    func makeOnboardingModule(injection: OnboardingModuleInjectionProtocol) -> any View
}

@MainActor
public protocol OnboardingModuleInjectionProtocol {
    var newsFeedBuilder: () -> any View { get }
}
