InstagramPhotoPicker
====================

![Version](https://img.shields.io/cocoapods/v/TWPhotoPicker.svg)
![License](https://img.shields.io/cocoapods/l/TWPhotoPicker.svg)
![Platform](https://img.shields.io/cocoapods/p/TWPhotoPicker.svg)

###TWInstagramPhotoPicker:###
Present Image Picker like Instagram

* lets you add custom actions to extend the picker
* allows you to select different photo albums

## Installation

With [CocoaPods](http://cocoapods.org/), add this line to your Podfile.

    pod 'TWPhotoPicker', '~> 1.0.1' or
    pod 'TWPhotoPicker', :git => 'https://github.com/vladzz/InstagramPhotoPicker.git'

## Screenshots
![Example](./Screenshots/Screenshot01.png "Example")
![Example2](./Screenshots/Screenshot02.png "Example2")
![Example3](./Screenshots/Screenshot03.png "Example3")


## Usage

```objective-c
    TWPhotoPickerController *photoPicker = [[TWPhotoPickerController alloc] init];
    photoPicker.cropBlock = ^(UIImage *image, NSURL *originalAssetURL) {
        //do something
    };
    [self presentViewController:photoPicker animated:YES completion:NULL];
```

## Requirements

- iOS 7 or higher
- Automatic Reference Counting (ARC)

## Author

- [wenzhaot](https://github.com/wenzhaot) ([@Wenzhaot](https://twitter.com/Wenzhaot))
- [vladzz](https://github.com/vladzz) ([@vladzz](https://twitter.com/vladzz))
- [mikeantonelli](https://github.com/mikeantonelli)

## License

TWPhotoPicker is released under the MIT license. See the LICENSE file for more info.
