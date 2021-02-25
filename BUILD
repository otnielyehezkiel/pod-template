load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
load("@build_bazel_rules_apple//apple:resources.bzl", "apple_resource_bundle")
load("@rules_apple_line//apple:objc_library.bzl", "objc_library")

objc_library(
    name = "${POD_NAME}",
    enable_modules = True,
    srcs = glob([
        "${POD_NAME}/**/*.m",
    ]),
    hdrs = glob(["${POD_NAME}/**/*.h"]),
    umbrella_header = "${POD_NAME}/${POD_NAME}.h",
    deps = [
        "//Modules/TVLKit:TVLKit",
    ],
    data = [
        ":${POD_NAME}ResourceBundle",
    ],
    sdk_frameworks = [
        "UIKit",
    ],
)

objc_library(
    name = "${POD_NAME}Tests",
    enable_modules = True,
    testonly = True,
    srcs = glob([
        "Tests/**/*.m",
    ]),
    data = [
        ":${POD_NAME}TestsResource"
    ],
    deps = [
        ":${POD_NAME}",
    ] + [
        "//Pods/Expecta:Expecta",
        "//Pods/OCMock:OCMock",
        "//Pods/Quick:Quick",
        "//Pods/Nimble:Nimble",
        "//Pods/Specta:Specta",
    ]
)

filegroup(
    name = "${POD_NAME}TestsResource",
    srcs = glob([
        "**/*.json"
    ]),
)

ios_unit_test(
    name = "${POD_NAME}TestsBundle",
    minimum_os_version = "11.0",
    deps = [
        ":${POD_NAME}Tests"
    ]
)

# Resources
apple_resource_bundle(
    name = "${POD_NAME}ResourceBundle",
    bundle_name = "${POD_NAME}Resources",
    infoplists = [
        '${POD_NAME}Resources/Info.plist'
    ],
    resources = glob([
        "${POD_NAME}Resources/Images.xcassets/**",
        "${POD_NAME}Resources/**/*.xib",
        "${POD_NAME}/**/*.xib"
    ])
)
