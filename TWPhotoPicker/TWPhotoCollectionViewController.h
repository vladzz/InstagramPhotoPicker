//
//  TWPhotoCollectionViewController.h
//  Pods
//
//  Created by Vlado Grancaric on 4/06/2015.
//
//

#import <UIKit/UIKit.h>
#import "TWAlbum.h"

@protocol TWPhotoCollectionDelegate <NSObject>

@required
-(void) didSelectPhoto:(UIImage*) photo atAssetURL:(NSURL*) assetURL andDropDraw:(BOOL) dropDraw;
-(void) didClickBackButton;

@optional
-(NSArray*) extraActions;

@end

@interface TWPhotoCollectionViewController : UICollectionViewController

/**
 This property represents an image we want to pre-select from the catalog when
 first visiting it.
 */
@property (nonatomic, strong) NSURL *imagePreselectURL;

@property (nonatomic, strong) TWAlbum *selectedAssetGroup;

@property (nonatomic, assign) id<TWPhotoCollectionDelegate> photoCollectiondelegate;

- (void) addScrollViewDelegate:(id<UIScrollViewDelegate>)delegate;
- (void) removeScrollViewDelegate:(id<UIScrollViewDelegate>)delegate;

- (void)loadData;

@end
