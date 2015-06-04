//
//  TWPhotoCollectionReusableView.m
//  Pods
//
//  Created by Vlado Grancaric on 3/06/2015.
//
//

#import "TWPhotoCollectionReusableView.h"

@implementation TWPhotoCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftButton setImage:[UIImage imageNamed:@"TWPhotoPicker.bundle/left.png"] forState:UIControlStateNormal];
//        self.leftButton.imageView.image = [UIImage imageNamed:@"TWPhotoPicker.bundle/left.png"];
        self.leftButton.frame = CGRectMake(15.0f, 16.5f, 16.0f, 11.0f);
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMidY(frame), frame.size.width, frame.size.height)];
        self.titleLabel.text = @"All photos";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.leftButton];
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.leftButton.frame = CGRectMake(15.0f, 16.5f, 16.0f, 11.0f);
    self.titleLabel.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
}

@end
