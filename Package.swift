// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//=----------------------------------------------------------------------------=
// MARK: Package
//=----------------------------------------------------------------------------=

/// TODO: Once done, use stable versions of remote packages or make local copies.
let package = Package(
    name: "DiffableTextViews",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "DiffableTextViews",
            targets: ["DiffableTextViews", "NumericTextStyles", "PatternTextStyles"]),
    ],
    dependencies: [
        //=--------------------------------------=
        // MARK: https://github.com/oscbyspro/
        //=--------------------------------------=
        .package(name: "Quick", url: "https://github.com/oscbyspro/Quick", .branch("main")),
        .package(name: "QuickText", url: "https://github.com/oscbyspro/QuickText", .branch("main")),
    ],
    targets: [
        //=--------------------------------------=
        // MARK: DiffableTextViews
        //=--------------------------------------=
        .target(
            name: "DiffableTextViews",
            dependencies: ["Quick", "QuickText"]),
        .testTarget(
            name: "DiffableTextViewsTests",
            dependencies: ["DiffableTextViews"]),
        //=--------------------------------------=
        // MARK: NumericTextStyles
        //=--------------------------------------=
        .target(
            name: "NumericTextStyles",
            dependencies: ["DiffableTextViews", "Quick"]),
        .testTarget(
            name: "NumericTextStylesTests",
            dependencies: ["NumericTextStyles"]),
        //=--------------------------------------=
        // MARK: PatternTextStyles
        //=--------------------------------------=
        .target(
            name: "PatternTextStyles",
            dependencies: ["DiffableTextViews", "Quick"]),
        .testTarget(
            name: "PatternTextStylesTests",
            dependencies: ["PatternTextStyles"]),
    ]
)
