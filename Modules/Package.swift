// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NewsViewer",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
          name: "Root", 
          targets: ["Root"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Root",
            dependencies: [
                "Onboarding",
                "OnboardingShared",
                "NewsFeed",
                "NewsFeedShared",
                "AppFoundation",
                "Services"
            ],
            path: "Sources/Root"
        ),
        .target(
            name: "AppFoundation",
            dependencies: [],
            path: "Sources/AppFoundation"
        ),
        .target(
            name: "CommonUI",
            dependencies: [
                "AppFoundation"
            ],
            path: "Sources/CommonUI"
        ),
        .target(
            name: "Services",
            dependencies: [
                "Models",
                "AppFoundation"
            ],
            path: "Sources/Services/Sources"
        ),
        .target(
            name: "NewsFeed",
            dependencies: [
                "Models",
                "Services",
                "CommonUI",
                "NewsFeedShared"
            ],
            path: "Sources/Features/NewsFeed",
            resources: [
              .process("Resources")
            ]
        ),
        .target(
            name: "NewsFeedShared",
            dependencies: [
                "Models",
                "Services",
                "AppFoundation",
            ],
            path: "Sources/FeaturesShared/NewsFeedShared"
        ),
        .target(
            name: "Onboarding",
            dependencies: [
                "CommonUI",
                "OnboardingShared"
            ],
            path: "Sources/Features/Onboarding"
        ),
        .target(
            name: "OnboardingShared",
            dependencies: [
                "Models",
                "Services",
                "AppFoundation"
            ],
            path: "Sources/FeaturesShared/OnboardingShared"
        ),
        .target(
            name: "Models",
            dependencies: [
                "AppFoundation"
            ],
            path: "Sources/Models"
        ),
        .testTarget(
            name: "NewsViewerTests",
            dependencies: [
                "Onboarding",
                "NewsFeed",
                "Models",
                "Services"
            ],
            path: "NewsViewerTests"
        ),
    ]
) 
