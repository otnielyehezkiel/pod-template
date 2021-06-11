require_relative '../../Scripts/pod_post_install'

install! 'cocoapods',
:generate_multiple_pod_projects => true,
:incremental_installation => true

${HEADER_PODS}

def module_dependency_pod
  pod 'MUIKit', :path => '../MUIKit'
  pod 'TVLFoundation', :path => '../TVLFoundation'
  pod 'TVLIconKit', :path => '../TVLIconKit'
  pod 'TVLModel', :path => '../TVLModel'
  pod 'TVLNetwork', :path => '../TVLNetwork'
  pod 'TVLStorage', :path => '../TVLStorage'
  pod 'TVLTracking', :path => '../TVLTracking'
  pod 'TVLUI', :path => '../TVLUI'
  pod 'TVLKit', :path => '../TVLKit'
  pod 'YogaKit', :path => '../YogaKit'

  # SwiftLinting
  pod 'SwiftLint', "= 0.37.0"

  # Yoga
  pod 'Yoga', :path => '../../react-native/ReactCommon/yoga', :modular_headers => false

  # Add third party pods here
  # pod 'AFNetworking', '= 3.2.1'
end

target 'SandboxApp' do
  module_dependency_pod

  pod '${POD_NAME}', :path => '.'

  ${INCLUDED_PODS}

  target '${POD_NAME}Tests' do
    pod 'TVLTestKit', :path => '../TVLTestKit'
  end

  target '${POD_NAME}EarlGreyHelper' do
    inherit! :search_paths
    
    pod 'TVLUITestKitHelperBundle', :path => '../TVLUITestKit/TVLUITestKitHelperBundle.podspec'
  end 
end

target '${POD_NAME}EarlGreyTest' do
  pod 'OCMock', '= 3.4.1'
  pod 'TVLUITestKitUIHostBundle', :path => '../TVLUITestKit/TVLUITestKitUIHostBundle.podspec'
end


post_install do |installer|

  # Overwriting Header Search Paths
  overwrite_header_search_path(installer, 'Pods-SandboxApp')

  # Auto Generated Umbrella Header for Internal Modules
  auto_generate_umbrella_header_modules(installer)
end
