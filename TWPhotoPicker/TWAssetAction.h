//
//  TWAssetAction.h
//  InstagramPhotoPicker
//
//  Created by Vlado Grancaric on 3/02/2015.
//  Copyright (c) 2015 wenzhaot. All rights reserved.
//
#import <UIKit/UIKit.h>

/**
 This Class represents a custom action.
 These can be selected within the photo list.
 */
@interface TWAssetAction : NSObject

/**
 The asset image to use
 */
@property(nonatomic,strong) UIImage *assetImage;

/**
 A block of custom code to be executed when the action is pressed
 */
@property(nonatomic, copy) void(^simpleBlock)();

/**
 The thumbnail to display
 */
@property(nonatomic, readonly) UIImage *thumbnail;

@end
