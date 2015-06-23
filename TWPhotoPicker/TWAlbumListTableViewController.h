//
//  TWAlbumListTableViewController.h
//  Pods
//
//  Created by Vlado Grancaric on 4/06/2015.
//
//

#import <UIKit/UIKit.h>
#import "TWAlbum.h"

@protocol TWAlbumListTableViewDelegate <NSObject>

-(void)albumSelected:(TWAlbum*) album;

@end

@interface TWAlbumListTableViewController : UITableViewController

@property(nonatomic, assign) id<TWAlbumListTableViewDelegate> albumListTableViewDelegate;

- (void) addScrollViewDelegate:(id<UIScrollViewDelegate>)delegate;
- (void) removeScrollViewDelegate:(id<UIScrollViewDelegate>)delegate;

@end
