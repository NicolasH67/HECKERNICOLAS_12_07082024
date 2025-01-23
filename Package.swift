// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Showdown-Master-Referee",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Showdown-Master-Referee",
            targets: ["Showdown-Master-Referee"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.2"),
    ],
    targets: [
        .target(
            name: "Showdown-Master-Referee",
            dependencies: ["Alamofire"],
            path: "App/SourceFiles"
        ),
        .testTarget(
            name: "Showdown-Master-RefereeTest",
            dependencies: ["Showdown-Master-Referee"],
            path: "App/Tests"
        ),
    ]
)
