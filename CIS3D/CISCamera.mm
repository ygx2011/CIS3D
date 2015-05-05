//
//  CISCamera.m
//  CIS3D
//
//  Created by Neo on 15/4/10.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISUtility.h"
#import "CISGeometry.h"
#import "CISCamera.h"

@interface CISCamera ()

@end

@implementation CISCamera

@synthesize P = _P;
@synthesize K = _K;
@synthesize R = _R;
@synthesize t = _t;

#pragma mark - life cycle
/* 在一个CISImagePair中，图像2由此method初始化，是相差一个 H 的 K [R | t] */
- (instancetype)initWithFundamentalMat:(cv::Mat *)F {
    self = [super init];
    if (self) {
        _P = new cv::Mat(3, 4, CV_64F);
        
        cv::SVD svd(*F);
        
        cv::Mat e = svd.u.col(2);
        cv::Mat tmp = -1 * [CISGeometry crossMatrix:e] * (*F);
        e.copyTo((*_P).col(3));
        tmp.copyTo( (*_P)(cv::Range(0, 3), cv::Range(0, 3)) );
        
        *_P /= tmp.at<double>(2, 2);
    }
    return self;
}

/* 图像1由此初始化，是默认的 [I | 0] */
- (instancetype)init {
    self = [super init];
    if (self) {
        _P = new cv::Mat(3, 4, CV_64F);

        cv::Mat zero = cv::Mat::zeros(3, 1, CV_64F);
        cv::Mat eye  = cv::Mat::eye(3, 3, CV_64F);
        zero.copyTo((*_P).col(3));
        eye.copyTo( (*_P)(cv::Range(0, 3), cv::Range(0, 3)) );
    }
    return self;
}

- (void)dealloc {
    delete _P;
    delete _K;
    delete _R;
    delete _t;
}

@end
