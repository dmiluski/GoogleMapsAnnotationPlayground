# GoogleMapsSDK Marker Transitions Demo

Demonstration of potential approach for animating pins between states

## Solved Issue (As of v8.0.0)

- [x] https://issuetracker.google.com/issues/204520941?pli=1

## Observed Issue (As of v8.0.0)

Changing zIndex results in blink update similar to reported issue above
- [ ] https://issuetracker.google.com/issues/285843951

| Demo |
| --- |
| ![GooglezIndexDemo](https://github.com/dmiluski/GoogleMapsAnnotationPlayground/assets/5083390/d49718e3-b578-4771-b66b-e7264350e262) |

Raw Video
https://github.com/dmiluski/GoogleMapsAnnotationPlayground/assets/5083390/4a231a38-292d-404d-8616-19cd0b27c00a


## Setup

Due to lack of SPM support, the easiest setup method involves installing
Follow xcFramework [Manual setup instructions](https://developers.google.com/maps/documentation/ios-sdk/config#install-the-xcframework)

1. Download SDK Source files: [GoogleMaps-8.0.0](https://dl.google.com/geosdk/2852f627534936c2fae7c11d69fd5a026813a66dd6ca555d751d14ae6cd1256e/GoogleMaps-8.0.0.tar.gz)
2. Drag the following XCFrameworks into the "Frameworks" folder in the ProjectDirectory

    - ProjectDir/Frameworks/GoogleMapsBase.xcframework
    - ProjectDir/Frameworks/GoogleMaps.xcframework
    - ProjectDir/Frameworks/GoogleMapsCore.xcframework
    - (Premium Plan customers only) GoogleMaps-x.x.x/GoogleMapsM4B.xcframework
    
3. Set your API key [here](https://github.com/dmiluski/GoogleMapsAnnotationPlayground/blob/sharableDemo/GoogleMapsAnnotationPlayground/ViewController.swift#L22)

## Earlier Example usage

| Using a simpler case and only chancing color |
| --- |
| Using the buttons in lower right, add, then update the marker (toggling between colors). On each update that enables, then disables tracksViewChanges the marker iconView will disappear, then re-appear on screen. Slow down the video (scrub it), and you will notice that you can see through the square marker between each update. |

https://user-images.githubusercontent.com/5083390/225731705-fb78fe5e-804d-4af0-a5ca-5f4c4b651f58.MP4


| Simulator Demo (No blinking) |
| --- |

https://user-images.githubusercontent.com/5083390/222257352-a6c66990-7082-4241-895a-e2fa662337f1.mp4


| Run on device (Blinking when content is updated |
| --- |
| If you download and scrub the video, you'll notice the marker's iconView is visible, disappears, then reappears on screen |

https://user-images.githubusercontent.com/5083390/222257011-b873442e-945e-466b-b368-7c6c4a32bdaf.MP4






