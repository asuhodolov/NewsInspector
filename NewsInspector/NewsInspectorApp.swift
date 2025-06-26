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
    @StateObject
    var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.rootView
        }
    }
}
