//
//  CISSfM.h
//  CIS3D
//
//  Created by Neo on 15/4/10.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <opencv2/opencv.hpp>

#import "CISConsts.h"
#import "CISCloud.h"
#import "CISImage.h"
#import "CISImagePair.h"

@interface CISSfM : NSObject

@property(atomic) NSMutableArray   *images;
@property(atomic) NSMutableArray   *pairs;
@property(atomic, strong) CISCloud *cloud;

+ (CISSfM *)sharedInstance;

@end
