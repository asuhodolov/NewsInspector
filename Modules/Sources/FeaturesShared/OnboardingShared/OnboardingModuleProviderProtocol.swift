//
//  NewsInspectorApp.swift
//  OnboardingShared.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import SwiftUI

@MainActor
public protocol OnboardingModuleInjectionProtocol {
    var newsFeedPresenter: NewsFeedPresenter { get }
}

@MainActor
public protocol NewsFeedPresenter {
    func presentNewsFeed()
}
