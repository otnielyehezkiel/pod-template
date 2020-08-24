require_relative '../../Scripts/pod_post_install'
${HEADER_PODS}

def module_dependency_pod
  pod 'MUIKit', :path => '../MUIKit'
  pod 'TVLFoundation', :path => '../TVLFoundation'
  pod 'TVLIconKit', :path => '../TVLIconKit'
  pod 'TVLNetwork', :path => '../TVLNetwork'
  pod 'TVLStorage', :path => '../TVLStorage'
  pod 'TVLUI', :path => '../TVLUI'
  pod 'YogaKit', :path => '../YogaKit'
  
  # Non module navigation TVLKit subspecs
  pod 'TVLKit', :path => '../TVLKit'
  
  # If you need to access USE_USER_CORE or USE_XSELL or USE_PAYMENT_CORE
  # for AppCoordinatorNavigationApi, you can commend pod 'TVLKit' above
  # and uncomment these below. Can uncomment more than 1 based on your req.
  #pod 'TVLKit/UserCore', :path => '../TVLKit'
  #pod 'TVLKit/CrossSell', :path => '../TVLKit'
  #pod 'TVLKit/PaymentCore', :path => '../TVLKit'

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
    pod 'Nimble', '= 8.0.1'
    pod 'OCMock', '= 3.4.1'
    pod 'Quick', '= 2.2.0'
  end
end

post_install do |installer|

  # Overwriting Header Search Paths
  overwrite_header_search_path(installer, 'Pods-SandboxApp')

  # Auto Generated Umbrella Header for Internal Modules
  auto_generate_umbrella_header_modules(installer)
end
