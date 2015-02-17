//
//  TWImageScrollView.h
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWImageScrollView : UIScrollView

@property(nonatomic, strong, readonly) NSURL *assetURL;

- (void)displayImage:(UIImage *)image andAssetURL:(NSURL*) assetURL;

- (UIImage *)capture;

@end
