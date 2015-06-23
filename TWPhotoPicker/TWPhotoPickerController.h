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
