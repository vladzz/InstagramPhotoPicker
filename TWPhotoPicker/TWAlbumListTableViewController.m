//
//  TWAlbumListTableViewController.m
//  Pods
//
//  Created by Vlado Grancaric on 4/06/2015.
//
//

#import "TWAlbumListTableViewController.h"
#import "TWAlbum.h"

static NSString *kCellAlbumIdentifier = @"kCellAlbumIdentifier";

@interface TWAlbumListTableViewController ()

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray *assetGroups;

@end

@implementation TWAlbumListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
            groupAlbum.assetGroup = group;
            
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.frame = self.view.superview.bounds;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

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
    cell.textLabel.text = [assetGroup.assetGroup valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSNumber numberWithInteger:[assetGroup.assetGroup numberOfAssets]].stringValue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate) {
        [self.delegate albumSelected:((TWAlbum*)self.assetGroups[indexPath.row]).assetGroup];
    }
}
@end
