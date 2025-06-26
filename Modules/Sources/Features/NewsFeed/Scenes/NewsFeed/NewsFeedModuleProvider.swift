//
//  NewsFeedModuleProvider.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 26/06/2025.
//

import Foundation
import SwiftUI
import AppFoundation
import NewsFeedShared

extension ModuleProvider {
    public static func makeNewsFeedModule(injection: NewsFeedModuleInjectionProtocol) -> any View {
        let newsFeedViewModel = NewsFeedViewModel(injection: injection)
        injection.captureViewModel(newsFeedViewModel)
        return NewsFeedView()
            .environmentObject(newsFeedViewModel)
    }
}
