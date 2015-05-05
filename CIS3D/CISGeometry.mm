//
//  CISGeometry.m
//  CIS3D
//
//  Created by Neo on 15/4/11.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISUtility.h"
#import "CISGeometry.h"

@interface CISGeometry ()

@end

@implementation CISGeometry

+ (cv::Mat)crossMatrix:(cv::Mat &)A {
    double x1 = A.at<double>(0, 0), x2 = A.at<double>(1, 0), x3 = A.at<double>(2, 0);
    cv::Mat Ax = (cv::Mat_<double>(3, 3) << 0, x3, -x2,
                                            -x3, 0, x1,
                                            x2, -x1, 0);
    return Ax;
}

@end
