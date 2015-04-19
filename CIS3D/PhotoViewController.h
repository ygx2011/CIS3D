//
//  ProcessImageViewController.h
//  CIS3D
//
//  Created by Neo on 15/4/14.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CISUtility.h"
#import "CISSfM.h"
#import "CISImage.h"
#import "CISImagePair.h"

@interface PhotoViewController : UIViewController

- (void)didReceiveImageAddedNotification:(NSNotification *)notification;
- (void)didReceiveImagePairAddedNotification:(NSNotification *)notification;

@end
