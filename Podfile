source 'git@github.com:CocoaPods/Specs.git'
source 'git@github.com:traveloka/Specs.git'

platform :ios, '11.0'
inhibit_all_warnings!
use_modular_headers!

ENV['SWIFT_VERSION'] = '5'

def module_dependency_pod
  # Add third party pods here
  # pod 'AFNetworking', '= 3.2.1'
end

target 'SandboxApp' do
  module_dependency_pod

  pod '${POD_NAME}', :path => '.'
end

target '${POD_NAME}' do
  module_dependency_pod

  target '${POD_NAME}Tests' do
    pod '${POD_NAME}', :path => '.'

    ${INCLUDED_PODS}
  end
end
