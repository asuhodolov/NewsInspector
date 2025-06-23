//
//  NewsInspectorApp.swift
//  NewsInspector
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import SwiftUI
import Root

@main
struct NewsInspectorApp: App {
    let appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            AnyView(appCoordinator.makeRootView())
        }
    }
}
