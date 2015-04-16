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

/* 维护的image、stereo-pair队列 */
@property (atomic) NSMutableArray     *images;
@property (atomic) NSMutableArray     *pairs;
@property (atomic, strong) CISCloud   *cloud;

/* 引入cache机制方便在ProcessImageController里显示 */
/* 这一机制与NSNotification放在一起有冗余，待考虑 */
/* 希望：引入新的segue，废弃cache机制 */
@property (nonatomic) cv::Mat *cachedMonoImage;
@property (nonatomic) cv::Mat *cachedStereoImage;

+ (CISSfM *)sharedInstance;
- (void)addImage:(CISImage *)image;

@end
