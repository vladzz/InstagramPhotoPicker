//
//  TWPhoto.m
//  Pods
//
//  Created by Vlado Grancaric on 3/06/2015.
//
//

#import "TWPhoto.h"

@implementation TWPhoto

- (UIImage *)thumbnailImage {
    return [UIImage imageWithCGImage:self.asset.thumbnail];
}

- (UIImage *)originalImage {
    return [UIImage imageWithCGImage:self.asset.defaultRepresentation.fullResolutionImage
                               scale:self.asset.defaultRepresentation.scale
                         orientation:(UIImageOrientation)self.asset.defaultRepresentation.orientation];
}

@end
