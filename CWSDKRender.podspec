Pod::Spec.new do |s|
    s.name                    = "CWSDKRender"
    s.version                 = "2.0.0"
    s.summary                 = "ConfigWiseSDK CWSDKRender (iOS) #{s.version}"
    s.homepage                = "https://github.com/configwise/configwise-sdk-ios-library"

    s.author                  = { "VipaHelda BV" => "sdk@configwise.io" }
    s.license                 = { :type => 'Apache-2.0', :file => 'LICENSE' }

    s.platform                = :ios
    s.ios.deployment_target   = '14.5'
    s.source                  = { :git => "https://github.com/configwise/configwise-sdk-ios-library.git", :tag => "#{s.version}" }

    s.frameworks = 'ARKit', 'RealityKit'
    s.dependency 'CWSDKData', '~> 2.0.0', :git => 'https://github.com/configwise/configwise-sdk-ios-library.git'

    s.ios.vendored_frameworks = "#{s.name}/Sources/#{s.name}.xcframework"
end