//
//  TWPhoto.h
//  Pods
//
//  Created by Vlado Grancaric on 3/06/2015.
//
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TWPhoto : NSObject

@property (nonatomic, readonly) UIImage *thumbnailImage;
@property (nonatomic, readonly) UIImage *originalImage;

@property (nonatomic, strong) ALAsset *asset;

@end
