//
//  ViewController.m
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import "ViewController.h"
#import "TWPhotoPickerController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSURL *originalAssetURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAction:(id)sender {
    TWPhotoPickerController *photoPicker = [[TWPhotoPickerController alloc] init];
    photoPicker.title = @"SELECT";
    
    if(self.originalAssetURL) {
        photoPicker.imagePreselectURL = self.originalAssetURL;
    }
    
    photoPicker.cropBlock = ^(UIImage *image, NSURL *originalAssetURL) {
        //do something
        self.imageView.image = image;
        self.originalAssetURL = originalAssetURL;
    };
    
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

@end
