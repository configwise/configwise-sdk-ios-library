Pod::Spec.new do |s|
    s.name                    = "ConfigWiseSDK"
    s.version                 = "2.0.0"
    s.summary                 = "ConfigWiseSDK (iOS) #{s.version}"
    s.homepage                = "https://github.com/configwise/configwise-sdk-ios-library"

    s.author                  = { "VipaHelda BV" => "sdk@configwise.io" }
    s.license                 = { :type => 'Apache-2.0', :file => 'LICENSE' }

    s.source                  = { :git => "https://github.com/configwise/configwise-sdk-ios-library.git", :tag => "#{s.version}" }

    s.platform                = :ios
    s.ios.deployment_target   = '14.5'

    s.subspec 'CWSDKData' do |dsp|
        dsp.vendored_frameworks = "CWSDKData/Sources/CWSDKData.xcframework"
        dsp.frameworks = 'CryptoKit'
    end

    s.subspec 'CWSDKRender' do |rsp|
        rsp.vendored_frameworks = "CWSDKRender/Sources/CWSDKRender.xcframework"
        rsp.frameworks = 'ARKit', 'RealityKit'
        rsp.dependency 'ConfigWiseSDK/CWSDKData'
    end
end
