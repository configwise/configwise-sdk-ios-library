Pod::Spec.new do |s|
    s.name                    = "ConfigWiseSDK"
    s.version                 = "2.0.1"
    s.summary                 = "#{s.name} (iOS) #{s.version}"
    s.homepage                = "https://github.com/configwise/configwise-sdk-ios-library"

    s.author                  = { "ConfigWise BV" => "sdk@configwise.io" }
    s.license                 = { :type => 'Apache-2.0', :file => 'LICENSE' }

    s.source                  = { :git => "#{s.homepage}.git", :tag => "#{s.version}" }

    s.platform                = :ios
    s.ios.deployment_target   = '14.5'

    s.subspec 'CWSDKData' do |dsp|
        dsp.vendored_frameworks = "CWSDKData/Sources/CWSDKData.xcframework"
        dsp.frameworks = 'CryptoKit'
    end

    s.subspec 'CWSDKRender' do |rsp|
        rsp.vendored_frameworks = "CWSDKRender/Sources/CWSDKRender.xcframework"
        rsp.frameworks = 'ARKit', 'RealityKit'
        rsp.dependency "#{s.name}/CWSDKData"
    end
end
