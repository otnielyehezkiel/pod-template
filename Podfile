source 'git@github.com:CocoaPods/Specs.git'
source 'git@github.com:traveloka/Specs.git'

platform :ios, '11.0'
inhibit_all_warnings!
use_modular_headers!

ENV['SWIFT_VERSION'] = '5'

target 'SandboxApp' do
  pod '${POD_NAME}', :path => '.'
end

target '${POD_NAME}Tests' do
  pod '${POD_NAME}', :path => '.'

  ${INCLUDED_PODS}
end
