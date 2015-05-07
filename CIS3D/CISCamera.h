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

- (instancetype)initWithFundamentalMat:(cv::Mat *)F
                       andIntrinsicMat:(cv::Mat *)K;
- (instancetype)initWithIntrinsicMat:(cv::Mat *)K;

#pragma mark - deprecated
- (instancetype)initWithFundamentalMat:(cv::Mat *)F;
- (instancetype)init;

@end
