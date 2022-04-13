# ConfigWiseSDK

## License

ConfigWiseSDK framework is distributed under [Apache-2.0](LICENSE) license.

## Installation:

**SPM (Swift Package Manager)**

Use the following repo URL to install `CWSDKData`, `CWSDKRender` libs: https://github.com/configwise/configwise-sdk-ios-library


**CocoaPods**

To add both `ConfigWiseSDK/CWSDKData` and `ConfigWiseSDK/CWSDKRender` libs, you can use:
```
pod 'ConfigWiseSDK', :git => 'https://github.com/configwise/configwise-sdk-ios-library.git'
```

If you only need `CWSDKData` lib, then:
```
pod 'ConfigWiseSDK/CWSDKData', :git => 'https://github.com/configwise/configwise-sdk-ios-library.git'
```

If `CWSDKRender` only, then:
```
pod 'ConfigWiseSDK/CWSDKRender', :git => 'https://github.com/configwise/configwise-sdk-ios-library.git'
```

## Initialization

```swift

import CWSDKData

. . .

ConfigWiseSDK.initialize([
    .channelToken("PUT_YOUR_CHANNEL_TOKEN_HERE"),
    .authMode(.b2c), // '.b2b' mode also available - in this case user accounts will be used by username / password auth method. 
    .testMode(false) // 'false' by default - means PRODUCTION ConfigWise service used underhood. Use 'true' to switch to TEST backend.
])

```

## CWSDKData

## CWSDKRender

## CWSDKExample
