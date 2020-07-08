#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = '${POD_NAME}'
  s.version          = '0.1.0'
  s.summary          = '${POD_NAME} is module level xx.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/${USER_NAME}/${POD_NAME}'
  s.author           = { '${USER_NAME}' => '${USER_EMAIL}' }
  s.source           = { :git => 'https://github.com/${USER_NAME}/${POD_NAME}.git', :tag => s.version.to_s }
  s.prefix_header_file = false
  s.ios.deployment_target = '11.0'

  s.source_files = '${POD_NAME}/**/*.{h,m,swift}'

  s.resource_bundles = {
    '${POD_NAME}Resources' => ['${POD_NAME}/**/*.xib',
                               '${POD_NAME}Resources/**/*.xib',
                               '${POD_NAME}Resources/Images.xcassets']
  }

  # Test Spec
  s.test_spec '${POD_NAME}Tests' do |test_spec|
    test_spec.source_files      = 'Tests/**/*.{m,swift}'

    test_spec.dependency "Nimble", "= 8.0.1"
    test_spec.dependency "OCMock", "= 3.4.1"
    test_spec.dependency "Quick", "= 2.2.0"

    # This prefix header is so that you don't need to import nimble or quick on objc files repeatedly
    test_spec.prefix_header_contents = '#define QUICK_DISABLE_SHORT_SYNTAX 1', '@import Nimble;', '@import OCMock;', '@import Quick;'
  end

  # s.public_header_files = '${POD_NAME}/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.pod_target_xcconfig = {
    "GCC_PREPROCESSOR_DEFINITIONS" => "MAS_SHORTHAND"
  }

  # Common modules. You may delete one of these module if you don't need it.
  # Don't forget to delete the dependency on your module Podfile too and run pod install.
  s.dependency 'TVLFoundation'
  s.dependency 'TVLKit'
  s.dependency 'TVLNetwork'
  s.dependency 'TVLStorage'
  s.dependency 'TVLUI'
end
