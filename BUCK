load("//Config:buck_rule_macros.bzl", "apple_test_lib", "apple_third_party_lib", "apple_create_bundle_resource")
load("//Config:app_configs.bzl", "PREBUILT_FRAMEWORKS", "PODS_TEST")

apple_third_party_lib(
    name = "${POD_NAME}",
    srcs = glob([
        "${POD_NAME}/**/*.swift",
        "${POD_NAME}/**/*.m",
    ]),
    exported_headers = glob([
        "${POD_NAME}/**/*.h"
    ]),
    deps = [
        ":${POD_NAME}ResourceBundle",

        "//Modules/TVLFoundation:TVLFoundation",
        "//Modules/TVLUI:TVLUI",
        "//Modules/TVLKit:TVLKit",
        "//Modules/TVLStorage:TVLStorage",
        "//Modules/TVLNetwork:TVLNetwork",
    ],
    frameworks = [
        "$SDKROOT/System/Library/Frameworks/Foundation.framework",
        "$SDKROOT/System/Library/Frameworks/UIKit.framework",
    ]
)

apple_test_lib(
    name = "${POD_NAME}Tests",
    srcs = glob([
        "Tests/**/*.m",
        "Tests/**/*.swift"
    ]),
    deps = [
        # All Deps
        ":${POD_NAME}",
    ] + PODS_TEST + PREBUILT_FRAMEWORKS
)

# Resources

apple_create_bundle_resource(
    rule_name = "${POD_NAME}ResourceBundle",
    bundle_resource_name = "${POD_NAME}Resources",
    info_plist = '${POD_NAME}Resources/Info.plist',
    image_xcassets_dirs = [
        "${POD_NAME}Resources/Images.xcassets"
    ],
    resource_dirs = glob([
        "${POD_NAME}Resources/**/*.xib",
        "${POD_NAME}/**/*.xib"
    ]),
)
