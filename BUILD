load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
load("@rules_apple_line//apple:apple_library.bzl", "apple_library")
load("//bazel:compiled_resource_bundle.bzl", "compiled_resource_bundle")
load("//Config:app_configs.bzl", "MINIMUM_OS_VERSION")

apple_library(
    name = "${POD_NAME}",
    enable_modules = True,
    srcs = glob([
        "${POD_NAME}/**/*.m",
        "${POD_NAME}/**/*.swift",
    ]),
    hdrs = glob(["${POD_NAME}/**/*.h"]),
    umbrella_header = "${POD_NAME}/${POD_NAME}.h",
    deps = [
        "//Modules/TVLKit:TVLKit",
    ],
    data = [
        ":${POD_NAME}Resources",
    ],
    sdk_frameworks = [
        "UIKit",
    ],
    objc_copts = [
        "-I$(BINDIR)/Modules/${POD_NAME}"
    ]
)

apple_library(
    name = "${POD_NAME}Tests",
    enable_modules = True,
    testonly = True,
    srcs = glob([
        "Tests/**/*.m",
        "Tests/**/*.swift",
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
    minimum_os_version = MINIMUM_IOS_VERSION,
    deps = [
        ":${POD_NAME}Tests"
    ]
)

# Resources
compiled_resource_bundle(
    name = "${POD_NAME}Resources",
    infoplist = '${POD_NAME}Resources/Info.plist',
    resources = glob([
        "${POD_NAME}Resources/Images.xcassets/**",
        "${POD_NAME}Resources/**/*.xib",
        "${POD_NAME}/**/*.xib"
    ])
)
