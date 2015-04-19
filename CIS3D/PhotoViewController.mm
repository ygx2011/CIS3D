//
//  ProcessImageViewController.m
//  CIS3D
//
//  Created by Neo on 15/4/14.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *monoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *stereoImageView;

- (void)didReceiveImageAddedNotification:(NSNotification *)notification;
- (void)didReceiveImagePairAddedNotification:(NSNotification *)notification;

@end

@implementation PhotoViewController {
    UIImage *_cachedMonoImage;
    UIImage *_cachedStereoImage;
}

@synthesize monoImageView   = _monoImageView;
@synthesize stereoImageView = _stereoImageView;

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    _monoImageView.image   = _cachedMonoImage;
    _stereoImageView.image = _cachedStereoImage;
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - update image frame when a new image comes in
- (void)didReceiveImageAddedNotification:(NSNotification *)notification {
    NSLog(@"ProcessImageViewController: Image get.");
    CISImage *image = [[notification userInfo] objectForKey:CISImageAdded];
    _cachedMonoImage = [CISImage UIImageFromCVMat:image.drawImage];
}

- (void)didReceiveImagePairAddedNotification:(NSNotification *)notification {
    NSLog(@"ProcessImageViewController: Image pair get.");
    CISImagePair *pair = [[notification userInfo] objectForKey:CISImagePairAdded];
    _cachedStereoImage = [CISImage UIImageFromCVMat:pair.drawImage];
}

@end
