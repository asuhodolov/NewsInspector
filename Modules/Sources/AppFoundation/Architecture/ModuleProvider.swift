//
//  ModuleProvider.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation

@MainActor
public final class ModuleProvider {
    private init() {}
}

public typealias CaptureViewModel = (_ viewModel: any ViewModel) -> Void

@MainActor
public protocol ViewModel: ObservableObject {}
