// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


// TODO [smuravev] See an example of SPM Package.swift, here: https://github.com/firebase/firebase-ios-sdk/blob/master/Package.swift
//                 Remove this comment, after we finally configure SPM based distribution.

let package = Package(
    name: "ConfigWiseSDK",
    platforms: [.iOS("14.5")],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CWSDKData",
            targets: ["CWSDKData"]
        ),
        .library(
            name: "CWSDKRender",
            targets: ["CWSDKRender"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .binaryTarget(
            name: "CWSDKData",
            dependencies: [],
            path: "CWSDKData/Sources/CWSDKData.xcframework"
        ),
        .binaryTarget(
            name: "CWSDKRender",
            dependencies: [
                // TODO [smuravev] Test if dependency really works as expected. Maybe replace it onto: `.target(name: "CWSDKData")`
                "CWSDKData"
            ],
            path: "CWSDKRender/Sources/CWSDKRender.xcframework",
            
            // TODO [smuravev] Test if the following 'linkerSettings' block required. Remove it of not.
            linkerSettings: [
                .linkedFramework("RealityKit", .when(platforms: [.iOS])),
            ]
        )
    ]
)
