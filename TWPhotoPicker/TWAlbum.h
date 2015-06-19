//
//  TWAlbum.h
//  Pods
//
//  Created by Vlado Grancaric on 15/06/2015.
//
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TWAlbum : NSObject

@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, strong) ALAssetsGroup *assetGroup;

@end
