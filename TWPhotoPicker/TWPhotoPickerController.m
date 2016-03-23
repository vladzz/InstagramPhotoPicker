//
//  TWPhotoPickerController.m
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import "TWPhotoPickerController.h"
#import "TWPhotoCollectionViewCell.h"
#import "TWImageScrollView.h"
#import "TWAssetAction.h"
#import "TWAlbum.h"
#import "TWPhoto.h"
#import "TWPhotoLoader.h"
#import "TWPhotoCollectionReusableView.h"
#import "TWPhotoCollectionViewController.h"
#import "TWAlbumListTableViewController.h"

@interface TWPhotoPickerController ()<TWPhotoCollectionDelegate, TWAlbumListTableViewDelegate, UIScrollViewDelegate>
{
    CGFloat beginOriginY;
}
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *cropBtn;

@property (strong, nonatomic) UIImageView *maskView;
@property (strong, nonatomic) TWImageScrollView *imageScrollView;

@property (strong, nonatomic) NSMutableArray *assets;

@property (strong, nonatomic) UIViewController *containerVC;

@property (strong, nonatomic) TWAlbumListTableViewController *albumListVC;

@property (strong, nonatomic) TWPhotoCollectionViewController *photoCollectionVC;

@property (nonatomic, weak) UIViewController *currentChildViewController;

@property (nonatomic, assign, getter=isDrawUp) BOOL drawUp;

@end

@implementation TWPhotoPickerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.customBackButtonImage = [UIImage my_bundleImageNamed:@"left.png"];
        self.cropButtonTitleColor = [UIColor cyanColor];
        self.cropButtonFont = [UIFont boldSystemFontOfSize:14.0f];
        self.cropButtonTitle = @"OK";
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.containerVC];
    [self.containerVC didMoveToParentViewController:self];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.topView];
    [self.view insertSubview:self.containerVC.view belowSubview:self.topView];
    
    [self.photoCollectionVC addScrollViewDelegate:self];
    [self.photoCollectionVC loadData];
    
    [self.containerVC addChildViewController:self.photoCollectionVC];
    [self.containerVC.view addSubview:self.photoCollectionVC.view];
    [self.photoCollectionVC didMoveToParentViewController:self.containerVC];
    self.currentChildViewController = self.photoCollectionVC;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.imagePreselectURL) {
        self.photoCollectionVC.imagePreselectURL = self.imagePreselectURL;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSMutableArray *)assets {
    if (_assets == nil) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (NSArray *)additionalAssets {
    if (_additionalAssets == nil) {
        _additionalAssets = [NSArray array];
    }
    return _additionalAssets;
}

- (UIView *)topView {
    if (_topView == nil) {
        CGFloat handleHeight = 40.0f + (self.isNotFullScreenMode? [UIApplication sharedApplication].statusBarFrame.size.height : 0.0f);
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)+handleHeight*2);
        self.topView = [[UIView alloc] initWithFrame:rect];
        self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.topView.backgroundColor = [UIColor clearColor];
        self.topView.clipsToBounds = YES;
        
        rect = CGRectMake(0, 0, CGRectGetWidth(self.topView.bounds), handleHeight);
        UIView *navView = [[UIView alloc] initWithFrame:rect];//26 29 33
        navView.backgroundColor = [[UIColor colorWithRed:36.0/255 green:37.0/255 blue:41.0/255 alpha:1] colorWithAlphaComponent:.8f];
        [self.topView addSubview:navView];
        
        rect = CGRectMake(0, 0, 60, CGRectGetHeight(navView.bounds));
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backBtn.frame = rect;
        self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(10., 20., 10., 20.);
        [self.backBtn setImage:self.customBackButtonImage forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:self.backBtn];
        
        rect = CGRectMake((CGRectGetWidth(navView.bounds)-200)/2, 0, 200, CGRectGetHeight(navView.bounds));
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
        titleLabel.text = self.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [navView addSubview:titleLabel];
        
        rect = CGRectMake(CGRectGetWidth(navView.bounds)-80, 0, 80, CGRectGetHeight(navView.bounds));
        self.cropBtn = [[UIButton alloc] initWithFrame:rect];
        [self.cropBtn setTitle:self.cropButtonTitle forState:UIControlStateNormal];
        [self.cropBtn.titleLabel setFont:self.cropButtonFont];
        [self.cropBtn setTitleColor:self.cropButtonTitleColor forState:UIControlStateNormal];
        [self.cropBtn addTarget:self action:@selector(cropAction) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:self.cropBtn];
        
        rect = CGRectMake(0, CGRectGetHeight(self.topView.bounds)-handleHeight, CGRectGetWidth(self.topView.bounds), handleHeight);
        UIView *dragView = [[UIView alloc] initWithFrame:rect];
        dragView.backgroundColor = [[UIColor colorWithRed:36.0/255 green:37.0/255 blue:41.0/255 alpha:1] colorWithAlphaComponent:.8f];
        dragView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.topView addSubview:dragView];
        
        UIImage *img = [UIImage my_bundleImageNamed:@"cameraroll-picker-grip.png"];
        rect = CGRectMake((CGRectGetWidth(dragView.bounds)-img.size.width)/2, (CGRectGetHeight(dragView.bounds)-img.size.height)/2, img.size.width, img.size.height);
        UIImageView *gripView = [[UIImageView alloc] initWithFrame:rect];
        gripView.image = img;
        [dragView addSubview:gripView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [dragView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [dragView addGestureRecognizer:tapGesture];
        
        [tapGesture requireGestureRecognizerToFail:panGesture];
        
        rect = CGRectMake(0, handleHeight, CGRectGetWidth(self.topView.bounds), CGRectGetHeight(self.topView.bounds)-handleHeight*2);
        self.imageScrollView = [[TWImageScrollView alloc] initWithFrame:rect];
        [self.topView addSubview:self.imageScrollView];
        [self.topView sendSubviewToBack:self.imageScrollView];
        
        self.maskView = [[UIImageView alloc] initWithFrame:rect];
        
        self.maskView.image = [UIImage my_bundleImageNamed:@"straighten-grid.png"];
        [self.topView insertSubview:self.maskView aboveSubview:self.imageScrollView];
    }
    return _topView;
}

- (UIViewController*) containerVC {
    if(_containerVC == nil) {
        _containerVC = [[UIViewController alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.topView.bounds));
        
        _containerVC.view.backgroundColor = [UIColor blackColor];
        _containerVC.view.frame = rect;
        _containerVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _containerVC;
}

- (TWAlbumListTableViewController *)albumListVC {
    if(_albumListVC == nil) {
        _albumListVC = [[TWAlbumListTableViewController alloc] init];
    }
    
    return _albumListVC;
}

- (TWPhotoCollectionViewController *)photoCollectionVC {
    if (_photoCollectionVC == nil) {
        
        CGFloat colum = 4.0, spacing = 2.0;
        CGFloat value = floorf((CGRectGetWidth(self.view.bounds) - (colum - 1) * spacing) / colum);
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake(value, value);
        layout.sectionInset                 = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        
        _photoCollectionVC = [[TWPhotoCollectionViewController alloc] initWithCollectionViewLayout:layout];
        _photoCollectionVC.photoCollectiondelegate = self;
        
    }
    return _photoCollectionVC;
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cropAction {
    if (self.cropBlock && !(self.imagePreselectURL && [self.imagePreselectURL isEqual:self.imageScrollView.assetURL])) {
        dispatch_async( dispatch_get_main_queue(), ^{
            self.cropBlock(self.imageScrollView.capture, self.imageScrollView.assetURL);
        });
    }
    [self backAction];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGRect topFrame = self.topView.frame;
            CGFloat endOriginY = self.topView.frame.origin.y;
            if (endOriginY > beginOriginY) {
                self.drawUp = NO;
                topFrame.origin.y = (endOriginY - beginOriginY) >= 20 ? 0 : -(CGRectGetHeight(self.topView.bounds)-20-44);
            } else if (endOriginY < beginOriginY) {
                self.drawUp = YES;
                topFrame.origin.y = (beginOriginY - endOriginY) >= 20 ? -(CGRectGetHeight(self.topView.bounds)-20-44) : 0;
            }
            
            CGRect containerFrame = self.containerVC.view.frame;
            containerFrame.origin.y = CGRectGetMaxY(topFrame);
            containerFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
            [UIView animateWithDuration:.3f animations:^{
                self.topView.frame = topFrame;
                self.containerVC.view.frame = containerFrame;
            }];
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            beginOriginY = self.topView.frame.origin.y;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:self.view];
            CGRect topFrame = self.topView.frame;
            topFrame.origin.y = translation.y + beginOriginY;
            
            CGRect collectionFrame = self.containerVC.view.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
            
            if (topFrame.origin.y <= 0 && (topFrame.origin.y >= -(CGRectGetHeight(self.topView.bounds)-20-44))) {
                self.topView.frame = topFrame;
                self.containerVC.view.frame = collectionFrame;
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    self.drawUp = !self.drawUp;
    
    CGRect topFrame = self.topView.frame;
    topFrame.origin.y = topFrame.origin.y == 0 ? -(CGRectGetHeight(self.topView.bounds)-20-44) : 0;
    
    CGRect containerFrame = self.containerVC.view.frame;
    containerFrame.origin.y = CGRectGetMaxY(topFrame);
    containerFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
    [UIView animateWithDuration:.3f animations:^{
        self.topView.frame = topFrame;
        self.containerVC.view.frame = containerFrame;
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSLog(@"velocity:%f", velocity.y);
    if (velocity.y >= 2.0 && self.topView.frame.origin.y == 0) {
        [self tapGestureAction:nil];
    }
}

#pragma mark - TWPhotoCollectionDelegate methods
-(NSArray*) extraActions {
    return self.additionalAssets;
}

-(void) didClickBackButton {
    // Containment
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    self.photoCollectionVC.imagePreselectURL = nil;
    self.photoCollectionVC.photoCollectiondelegate = nil;
    [self.photoCollectionVC removeScrollViewDelegate:self];
    self.albumListVC.albumListTableViewDelegate = self;
    [self.albumListVC addScrollViewDelegate:self];
    
    [self.containerVC addChildViewController:self.albumListVC];
    
    self.albumListVC.view.frame = self.containerVC.view.bounds;
    [self.currentChildViewController willMoveToParentViewController:nil];
    
    self.albumListVC.view.transform = CGAffineTransformMakeTranslation(-width, 0);
    
    [self.containerVC transitionFromViewController:self.currentChildViewController toViewController:self.albumListVC duration:0.3f options:0 animations:^{

        self.currentChildViewController.view.transform = CGAffineTransformMakeTranslation(width, 0);
        self.albumListVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [self.albumListVC didMoveToParentViewController:self.containerVC];
        [self.currentChildViewController removeFromParentViewController];
        [self.currentChildViewController didMoveToParentViewController:nil];
        self.currentChildViewController = self.albumListVC;
    }];
}

-(void) didSelectPhoto:(UIImage*) photo atAssetURL:(NSURL*) assetURL andDropDraw:(BOOL) dropDraw {
    [self.imageScrollView displayImage:photo andAssetURL:assetURL];
    
    if (dropDraw && self.topView.frame.origin.y != 0) {
        [self tapGestureAction:nil];
    }
    
}

#pragma mark - TWAlbumListTableViewDelegate methods
-(void)albumSelected:(TWAlbum*) assetGroup {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    self.albumListVC.albumListTableViewDelegate = nil;
    [self.albumListVC removeScrollViewDelegate:self];
    self.photoCollectionVC.photoCollectiondelegate = self;
    self.photoCollectionVC.selectedAssetGroup = assetGroup;
    [self.photoCollectionVC loadData];
    [self.photoCollectionVC addScrollViewDelegate:self];
    [self.containerVC addChildViewController:self.photoCollectionVC];
    [self.currentChildViewController willMoveToParentViewController:nil];
    
    self.photoCollectionVC.view.transform = CGAffineTransformMakeTranslation(width, 0);
    
    [self.containerVC transitionFromViewController:self.currentChildViewController toViewController:self.photoCollectionVC duration:0.3f options:0 animations:^{

        self.currentChildViewController.view.transform = CGAffineTransformMakeTranslation(-width, 0);
        self.photoCollectionVC.view.transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {
        self.albumListVC.view.transform = CGAffineTransformIdentity;
        [self.photoCollectionVC didMoveToParentViewController:self.containerVC];
        [self.currentChildViewController removeFromParentViewController];
        [self.currentChildViewController didMoveToParentViewController:nil];
        self.currentChildViewController = self.photoCollectionVC;
    }];
}

@end
