//
//  TWPhotoLoader.h
//  Pods
//
//  Created by Emar on 4/30/15.
//
//
#import <Foundation/Foundation.h>
#import "TWPhoto.h"

typedef void (^loadBlock)(NSArray *photos, NSError *error);

@interface TWPhotoLoader : NSObject

@property (strong, nonatomic) NSMutableArray *allPhotos;

+ (TWPhotoLoader *)sharedLoader;

+ (void)loadAllPhotos:(void (^)(NSArray *photos, NSError *error))completion;
+ (void)loadAllPhotosInGroup:(ALAssetsGroup*) group andCompletion:(void (^)(NSArray *photos, NSError *error))completion;

@end
