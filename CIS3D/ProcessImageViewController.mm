//
//  ProcessImageViewController.m
//  CIS3D
//
//  Created by Neo on 15/4/14.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "ProcessImageViewController.h"

@interface ProcessImageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *monoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *stereoImageView;


- (void)didReceiveImageAddedNotification:(NSNotification *)notification;
- (void)didReceiveImagePairAddedNotification:(NSNotification *)notification;

@end

@implementation ProcessImageViewController

@synthesize monoImageView   = _monoImageView;
@synthesize stereoImageView = _stereoImageView;

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Process view loaded");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveImageAddedNotification:)
                                                 name:CISImageAddedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveImagePairAddedNotification:)
                                                 name:CISImagePairAddedNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - update image frame when a new image comes in
- (void)didReceiveImageAddedNotification:(NSNotification *)notification {
    NSLog(@"ProcessImageViewController: Image get.");
    CISImage *image = [[notification userInfo] objectForKey:CISImageAdded];
    _monoImageView.image = [CISImage UIImageFromCVMat:image.drawImage];
}

- (void)didReceiveImagePairAddedNotification:(NSNotification *)notification {
    NSLog(@"ProcessImageViewController: Image pair get");
    CISImagePair *pair = [[notification userInfo] objectForKey:CISImagePairAdded];
    _stereoImageView.image = [CISImage UIImageFromCVMat:pair.drawImage];
}

@end
