//
//  CISCamera.h
//  CIS3D
//
//  Created by Neo on 15/4/10.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <opencv2/opencv.hpp>

@interface CISCamera : NSObject

/* P = K [ R | t] */
@property (nonatomic) cv::Matx34d P;
@property (nonatomic) cv::Mat    *K;
@property (nonatomic) cv::Mat    *KInv;

- (instancetype)init;
- (instancetype)initWithR:(cv::Mat)R andT:(cv::Mat)t;

@end
