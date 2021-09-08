load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
load("@build_bazel_rules_apple//apple:resources.bzl", "apple_resource_bundle")
load("@rules_apple_line//apple:swift_library.bzl", "swift_library")
load("//Config:app_configs.bzl", "MINIMUM_OS_VERSION")

swift_library(
    name = "${POD_NAME}",
    srcs = glob([
        "${POD_NAME}/**/*.swift",
    ]),
    deps = [
        "//Modules/TVLKit:TVLKit",
    ],
    data = [
        ":${POD_NAME}Resources",
    ],
)

swift_library(
    name = "${POD_NAME}Tests",
    enable_modules = True,
    testonly = True,
    srcs = glob([
        "Tests/**/*.swift",
    ]),
    data = [
        ":${POD_NAME}TestsResource"
    ],
    deps = [
        ":${POD_NAME}",
    ] + [
        "//Modules/TVLTestKit:TVLTestKit",
        "//Pods/Quick:Quick",
        "//Pods/Nimble:Nimble",
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
    minimum_os_version = MINIMUM_OS_VERSION,
    deps = [
        ":${POD_NAME}Tests"
    ]
)

# Resources
apple_resource_bundle(
    name = "${POD_NAME}Resources",
    infoplists = [
        '${POD_NAME}Resources/Info.plist',
    ],
    resources = glob([
        "${POD_NAME}Resources/Images.xcassets/**",
        "${POD_NAME}Resources/**/*.xib",
        "${POD_NAME}/**/*.xib"
    ])
)
