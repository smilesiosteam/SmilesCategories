// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesCategories",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SmilesCategories",
            targets: ["SmilesCategories"]),
    ],
    dependencies: [
        .package(url: "https://github.com/smilesiosteam/SmilesUtilities.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesSharedServices.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesAppHeader.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesStoriesManager.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesOffers.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesBanners.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesFilterAndSort.git", branch: "main"),
        .package(url: "https://github.com/wxxsw/SwiftTheme.git", branch: "master"),
        .package(url: "https://github.com/smilesiosteam/SmilesReusableComponents.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesPersonalizationEvent.git", branch: "main")
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "SmilesCategories",
               dependencies: [
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "SmilesSharedServices", package: "SmilesSharedServices"),
                .product(name: "AppHeader", package: "SmilesAppHeader"),
                .product(name: "SmilesStoriesManager", package: "SmilesStoriesManager"),
                .product(name: "SmilesOffers", package: "SmilesOffers"),
                .product(name: "SmilesBanners", package: "SmilesBanners"),
                .product(name: "SmilesFilterAndSort", package: "SmilesFilterAndSort"),
                .product(name: "SwiftTheme", package: "SwiftTheme"),
                .product(name: "SmilesReusableComponents", package: "SmilesReusableComponents"),
                .product(name: "SmilesPersonalizationEvent", package: "SmilesPersonalizationEvent")
                
               ]),
        .testTarget(
            name: "SmilesCategoriesTests",
            dependencies: ["SmilesCategories"]),
    ]
)
