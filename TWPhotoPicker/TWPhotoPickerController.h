//
//  TWPhotoPickerController.h
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWPhotoPickerController : UIViewController

/**
 These are additional Assets which get tacked on to the existing assets.
 They can be actionable e.g. Camera icon
 */
@property (nonatomic, strong) NSArray *additionalAssets;

@property (nonatomic, copy) void(^cropBlock)(UIImage *image, NSURL *originalAssetURL);

@property (nonatomic, assign, getter=isNotFullScreenMode) BOOL notFullScreenMode;

/**
 This property represents an image we want to pre-select from the catalog when
 first visiting it.
 */
@property (nonatomic, strong) NSURL *imagePreselectURL;

/**
 This property allows the cusotmisation of the back button image.
 */
@property (nonatomic, strong) UIImage *customBackButtonImage;
/**
 Change the font on the crop button
 */
@property (nonatomic, strong) UIFont *cropButtonFont;
/**
 Change the cop button Title color
 */
@property (nonatomic, strong) UIColor *cropButtonTitleColor;

/**
 Change the title which is displayed on the crop button
 */
@property (nonatomic, strong) NSString *cropButtonTitle;
@end

#pragma mark - Helper

@interface NSBundle (MyLibrary)

+ (NSBundle *)my_myLibraryBundle;
+ (NSURL *)my_myLibraryBundleURL;

@end

@implementation NSBundle (MyLibrary)

+ (NSBundle *)my_myLibraryBundle {
    return [self bundleWithURL:[self my_myLibraryBundleURL]];
}


+ (NSURL *)my_myLibraryBundleURL {
    NSBundle *bundle = [NSBundle bundleForClass:[TWPhotoPickerController class]];
    return [bundle URLForResource:@"TWPhotoPicker" withExtension:@"bundle"];
}

@end

@interface UIImage (MyLibrary)

+ (UIImage *)my_bundleImageNamed:(NSString *)name;

@end

@implementation UIImage (MyLibrary)

+ (UIImage *)my_bundleImageNamed:(NSString *)name {
    return [self my_imageNamed:name inBundle:[NSBundle my_myLibraryBundle]];
}

+ (UIImage *)my_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [self imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [self imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
#else
    if ([self respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [self imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [self imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
    }
#endif
}

@end