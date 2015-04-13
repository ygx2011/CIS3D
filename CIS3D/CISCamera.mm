//
//  CISCamera.m
//  CIS3D
//
//  Created by Neo on 15/4/10.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISCamera.h"

@interface CISCamera ()

@end

@implementation CISCamera

@synthesize P = _P;
@synthesize K = _K;
@synthesize R = _R;
@synthesize t = _t;

#pragma mark - life cycle
- (instancetype)initWithFundamentalMat:(cv::Mat &)F {
    self = [super init];
    if (self) {
        _P = new cv::Mat(3, 4, CV_64F);
        
        cv::SVD svd(F);
        
        cv::Mat e = svd.u.col(2);
        cv::Mat tmp = -1 * [CISGeometry crossMatrix:e] * F;
        e.copyTo(*_P);
        tmp.copyTo( (*_P)(cv::Range(0, 3), cv::Range(0, 3)) );
        
        *_P /= tmp.at<double>(2, 2);
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
