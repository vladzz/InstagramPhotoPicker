//
//  TWAlbumListTableViewController.m
//  Pods
//
//  Created by Vlado Grancaric on 4/06/2015.
//
//

#import "TWAlbumListTableViewController.h"

static NSString *kCellAlbumIdentifier = @"kCellAlbumIdentifier";

@interface TWAlbumListTableViewController ()

@property(nonatomic, strong) NSMutableArray *scrollListeners;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray *assetGroups;

@end

@implementation TWAlbumListTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollListeners = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 14, 0, 0);
    self.tableView.separatorColor = [UIColor colorWithRed:46.0/255 green:47.0/255 blue:49.0/255 alpha:1];
    self.tableView.rowHeight = 48.f;
    
    self.view.backgroundColor = [UIColor colorWithRed:23.0/255 green:24.0/255 blue:26.0/255 alpha:1];
    
    self.assetGroups = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.assetGroups removeAllObjects];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        
        if (group && [group numberOfAssets] > 0) {
            NSNumber *number = [group valueForProperty:ALAssetsGroupPropertyType];
            int groupAll = 16 ;
            
            TWAlbum *groupAlbum = [[TWAlbum alloc] init];
//            groupAlbum.assetGroup = group;
            groupAlbum.groupType = number;
            groupAlbum.thumbnailImage = [UIImage imageWithCGImage:group.posterImage scale:4 orientation:UIImageOrientationUp];
            groupAlbum.albumURL = [group valueForProperty:ALAssetsGroupPropertyURL];
            groupAlbum.albumName = [group valueForProperty:ALAssetsGroupPropertyName];
            groupAlbum.numberOfAssets = [NSNumber numberWithInteger:[group numberOfAssets]];
            
            if([number intValue] == groupAll) {
                [self.assetGroups insertObject:groupAlbum atIndex:0];
            } else {
                [self.assetGroups addObject:groupAlbum];
            }
        }
        
        if(group == nil) {
            [self.tableView reloadData];
        }
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        //TODO an error has happened
    }];
    
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  @"Called" );
//    self.view.frame = self.view.superview.bounds;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (void) addScrollViewDelegate:(id<UIScrollViewDelegate>)delegate {
    if (![self.scrollListeners containsObject:delegate]) {
        [self.scrollListeners addObject:delegate];
    }
}

- (void) removeScrollViewDelegate:(id<UIScrollViewDelegate>)delegate {
    if ([self.scrollListeners containsObject:delegate]) {
        [self.scrollListeners removeObject:delegate];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    if(self.scrollListeners) {
        for(id<UIScrollViewDelegate> observer in self.scrollListeners) {
            if (observer) {
                [observer scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetGroups.count;
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellAlbumIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellAlbumIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:23.0/255 green:24.0/255 blue:26.0/255 alpha:1];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.tintColor = [UIColor grayColor];
    }
    
    TWAlbum *assetGroup = self.assetGroups[indexPath.row];
    UIImage *image = assetGroup.thumbnailImage;
    cell.imageView.image = image;
    cell.textLabel.text = assetGroup.albumName;
    cell.detailTextLabel.text = assetGroup.numberOfAssets.stringValue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.albumListTableViewDelegate) {
        [self.albumListTableViewDelegate albumSelected:((TWAlbum*)self.assetGroups[indexPath.row])];
    }
}
@end
