//
//  TWAlbumListTableViewController.h
//  Pods
//
//  Created by Vlado Grancaric on 4/06/2015.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol TWAlbumListTableViewDelegate <NSObject>

-(void)albumSelected:(ALAssetsGroup*) assetGroup;

@end

@interface TWAlbumListTableViewController : UITableViewController

@property(nonatomic, assign) id<TWAlbumListTableViewDelegate> delegate;

@end
