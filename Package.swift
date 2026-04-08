// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CodingPlanTracker-Lightweight",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(name: "CodingPlanSDK", targets: ["CodingPlanSDK"])
    ],
    targets: [
        .target(
            name: "CodingPlanSDK",
            path: "Sources/CodingPlanSDK"
        ),
        .executableTarget(
            name: "CodingPlanTracker-iOS",
            dependencies: ["CodingPlanSDK"],
            path: "Sources/CodingPlanTracker-iOS"
        ),
        .executableTarget(
            name: "CodingPlanTracker-WatchOS",
            dependencies: ["CodingPlanSDK"],
            path: "Sources/CodingPlanTracker-WatchOS"
        )
    ]
)