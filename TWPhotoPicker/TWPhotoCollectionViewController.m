//
//  TWPhotoCollectionViewController.m
//  Pods
//
//  Created by Vlado Grancaric on 4/06/2015.
//
//

#import "TWPhotoCollectionViewController.h"
#import "TWPhotoCollectionViewCell.h"
#import "TWPhotoCollectionReusableView.h"
#import "TWAssetAction.h"
#import "TWPhotoLoader.h"

static NSString *kPhotoCollectionViewCellIdentifier = @"TWPhotoCollectionViewCell";
static NSString *kPhotoCollectionReusableView = @"TWPhotoCollectionReusableView";
static NSUInteger kHeaderHeight = 44;
@interface TWPhotoCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *assets;

@end

@implementation TWPhotoCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.allowsMultipleSelection = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[TWPhotoCollectionViewCell class] forCellWithReuseIdentifier:kPhotoCollectionViewCellIdentifier];
    [self.collectionView registerClass:[TWPhotoCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPhotoCollectionReusableView];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadPhotos];

    NSNumber *number = nil;
    int groupAll = 16;
    
    if(self.selectedAssetGroup) {
        number = [self.selectedAssetGroup valueForProperty:ALAssetsGroupPropertyType];
    }
    
    if(self.selectedAssetGroup == nil || [number intValue] == groupAll) {
        self.collectionView.contentOffset = CGPointMake(0.0f, kHeaderHeight);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[[TWPhotoLoader sharedLoader] allPhotos] removeAllObjects];
    [self.collectionView reloadData];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.frame = self.view.superview.bounds;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (NSMutableArray *)assets {
    if (_assets == nil) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (void)loadPhotos {
    loadBlock photoBlock = ^(NSArray *photos, NSError *error) {
        if (!error) {
            self.assets = [NSMutableArray arrayWithArray:photos];
            if (self.assets.count) {
                if(self.imagePreselectURL) {
                    
                    NSUInteger foundIndex = [self.assets indexOfObjectPassingTest:^BOOL(TWPhoto *obj, NSUInteger idx, BOOL *stop) {
                        NSURL *assetURL = [obj.asset valueForProperty:ALAssetPropertyAssetURL];

                        return [assetURL.absoluteString isEqualToString:self.imagePreselectURL.absoluteString];
                        
                    }];
                    
                    if(foundIndex != NSNotFound) {
                        TWPhoto *asset = ((TWPhoto*)self.assets[foundIndex]);
                        if(self.delegate) {
                            [self.delegate didSelectPhoto:asset.originalImage atAssetURL:[asset.asset valueForProperty:ALAssetPropertyAssetURL] andDropDraw:NO];
                        }
                    } else {
                        TWPhoto *firstPhoto = self.assets[0];
                        if(self.delegate) {
                            [self.delegate didSelectPhoto:firstPhoto.originalImage atAssetURL:[firstPhoto.asset valueForProperty:ALAssetPropertyAssetURL] andDropDraw:NO];
                        }
                    }
                } else {
                    TWPhoto *firstPhoto = self.assets[0];
                    if(self.delegate) {
                        [self.delegate didSelectPhoto:firstPhoto.originalImage atAssetURL:[firstPhoto.asset valueForProperty:ALAssetPropertyAssetURL] andDropDraw:NO];
                    }
                }
            }
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(extraActions)]) {
                [self loadExtraActions:[self.delegate extraActions]];
                
                
            }
            
            [self.collectionView reloadData];
        } else {
            NSLog(@"Load Photos Error: %@", error);
        }
        
    };
    
    if(self.selectedAssetGroup) {
        [TWPhotoLoader loadAllPhotosInGroup:self.selectedAssetGroup andCompletion:photoBlock];
    } else {
        [TWPhotoLoader loadAllPhotos:photoBlock];
    }
    
}

- (void)loadExtraActions:(NSArray*) additionalAssets {
    if(additionalAssets && additionalAssets.count > 0) {
        for(NSObject *actions in additionalAssets) {
            [self.assets insertObject:actions atIndex:0];
        }
    }
}

-(void)backButtonClicked {
    if(self.delegate) {
        [self.delegate didClickBackButton];
    }
}

#pragma mark - Collection View Data Source
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    TWPhotoCollectionReusableView *reusableview = [collectionView
                                              dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPhotoCollectionReusableView forIndexPath:indexPath];
    
    [reusableview.leftButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    reusableview.titleLabel.text = self.selectedAssetGroup? [[self.selectedAssetGroup valueForProperty:ALAssetsGroupPropertyName] uppercaseString] : [@"All photos" uppercaseString];
    return reusableview;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if([self.assets[(NSUInteger) indexPath.row] isKindOfClass:[TWAssetAction class]]) {
        TWAssetAction *action = ((TWAssetAction*)self.assets[(NSUInteger) indexPath.row]);
        cell.imageView.image = action.thumbnail? action.thumbnail : action.assetImage;
    } else {
        cell.imageView.image = [self.assets[(NSUInteger) indexPath.row] thumbnailImage];
    }
    
    return cell;
}

#pragma mark - Collection View Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    CGSize size = CGSizeMake(collectionView.frame.size.width, kHeaderHeight);

    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.assets[(NSUInteger) indexPath.row] isKindOfClass:[TWAssetAction class]]) {
        TWAssetAction *action = self.assets[(NSUInteger) indexPath.row];
        
        /**
         If these is a block defined we use it.
         otherwise we display the original asset image.
         */
        if(action.simpleBlock) {
            action.simpleBlock();
        } else {
            if(self.delegate) {
                [self.delegate didSelectPhoto:action.assetImage atAssetURL:nil andDropDraw:NO];
            }
        }
    } else {
        
        TWPhoto * asset = self.assets[(NSUInteger) indexPath.row];
        UIImage *image = asset.originalImage;
        if(self.delegate) {
            [self.delegate didSelectPhoto:image atAssetURL:nil andDropDraw:YES];
        }
    }
}

@end
