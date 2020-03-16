${HEADER_PODS}

def module_dependency_pod
  pod 'MUIKit', :path => '../MUIKit'
  pod 'TVLFoundation', :path => '../TVLFoundation'
  #pod 'TVLNetwork', :path => '../TVLNetwork'
  #pod 'TVLStorage', :path => '../TVLStorage'
  pod 'TVLUI', :path => '../TVLUI'
  pod 'TVLKit', :path => '../TVLKit'

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

# Add MAS_SHORTHAND=1 by default in your module target
# (not reflecting Traveloka app or SandboxApp)
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == '${POD_NAME}'
      target.build_configurations.each do |config|
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'MAS_SHORTHAND=1']
      end
    end
  end
end
