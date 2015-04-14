//
//  CISGeometry.h
//  CIS3D
//
//  Created by Neo on 15/4/11.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <opencv2/opencv.hpp>

#import "CISConsts.h"

@interface CISGeometry : NSObject

+ (cv::Mat)crossMatrix:(cv::Mat &)mat;

@end
