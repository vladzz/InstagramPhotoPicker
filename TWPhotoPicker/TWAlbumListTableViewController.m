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

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray *assetGroups;

@end

@implementation TWAlbumListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 14, 0, 0);
    
    self.view.backgroundColor = [UIColor blackColor];
    
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
            [self.assetGroups addObject:group];
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
    CGRect superFrame = self.view.superview.frame;
    superFrame.origin.y = 0.0f;
    superFrame.origin.x = 0.0f;
    self.view.frame = superFrame;
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
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ALAssetsGroup *assetGroup = self.assetGroups[indexPath.row];
    UIImage *image = [UIImage imageWithCGImage:[assetGroup posterImage]];
    cell.imageView.image = image;
    cell.textLabel.text = [assetGroup valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSNumber numberWithInteger:[assetGroup numberOfAssets]].stringValue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate) {
        [self.delegate albumSelected:self.assetGroups[indexPath.row]];
    }
}
@end
