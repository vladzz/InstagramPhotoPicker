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

@property (nonatomic, copy) void(^cropBlock)(UIImage *image);

@property (nonatomic, assign, getter=isNotFullScreenMode) BOOL notFullScreenMode;

@end
