//
//  ProcessImageViewController.m
//  CIS3D
//
//  Created by Neo on 15/4/14.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "ProcessImageViewController.h"

@interface ProcessImageViewController ()

@property(strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)didReceiveImageAddedNotification:(NSNotification *)notification;

@end

@implementation ProcessImageViewController

@synthesize imageView = _imageView;

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Process view loaded");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveImageAddedNotification:)
                                                 name:CISImageAddedNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - update image frame when a new image comes in
- (void)didReceiveImageAddedNotification:(NSNotification *)notification {
    NSLog(@"Get it");
    CISImage *image = [[notification userInfo] objectForKey:CISImageAdded];
    _imageView.image = [CISImage UIImageFromCVMat:*(image.featuredImage)];
}
@end
