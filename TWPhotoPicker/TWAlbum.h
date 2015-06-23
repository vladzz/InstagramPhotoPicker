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

@property (nonatomic, strong) NSString *albumName;

@property (nonatomic, strong) NSURL *albumURL;

@property (nonatomic, strong) NSNumber *groupType;
@property (nonatomic, strong) NSNumber *numberOfAssets;
@property (nonatomic, strong) ALAssetsGroup *assetGroup;

@end
