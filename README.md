# GoogleMapsSDK Marker Transitions Demo

Demonstration of potential approach for animating pins between states

## Issue

https://issuetracker.google.com/issues/204520941?pli=1

## Setup

Due to lack of SPM support, the easiest setup method involves installing
Follow xcFramework [Manual setup instructions](https://developers.google.com/maps/documentation/ios-sdk/config#install-the-xcframework)

1. Download SDK Source files: [GoogleMaps-7.4.0](https://dl.google.com/geosdk/12cdf90d54d85bfcc90d340148d86362ee3189ea24b4bd20ca891e9bd33ded21/GoogleMaps-7.4.0.tar.gz)
2. Drag the following XCFrameworks into the "Frameworks" folder in the ProjectDirectory

    - ProjectDir/Frameworks/GoogleMapsBase.xcframework
    - ProjectDir/Frameworks/GoogleMaps.xcframework
    - ProjectDir/Frameworks/GoogleMapsCore.xcframework
    - (Premium Plan customers only) GoogleMaps-x.x.x/GoogleMapsM4B.xcframework
    
3. Set your API key [here](https://github.com/dmiluski/GoogleMapsAnnotationPlayground/blob/sharableDemo/GoogleMapsAnnotationPlayground/ViewController.swift#L22)

## Example usage

| Simulator Demo (No blinking) |
| --- |

https://user-images.githubusercontent.com/5083390/222257352-a6c66990-7082-4241-895a-e2fa662337f1.mp4

| Run on device (Blinking when content is updated |
| --- |
| If you download and scrub the video, you'll notice the marker's iconView is visible, disappears, then reappears on screen |

https://user-images.githubusercontent.com/5083390/222257011-b873442e-945e-466b-b368-7c6c4a32bdaf.MP4





| ![MockMarkerTransitionDemo](https://media.git.musta.ch/user/8819/files/23851e14-e3af-44dd-b476-85e83b5e6996) |
