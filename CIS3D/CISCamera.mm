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
@synthesize KInv = _KInv;

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupK];
        
        _P = cv::Matx34d(1, 0, 0, 0,
                         0, 1, 0, 0,
                         0, 0, 1, 0);
    }
    return self;
}

- (instancetype)initWithR:(cv::Mat)R andT:(cv::Mat)t {
    self = [super init];
    if (self) {
        [self setupK];
        
        _P = cv::Matx34d(R.at<double>(0, 0), R.at<double>(0, 1), R.at<double>(0, 2), t.at<double>(0, 0),
                         R.at<double>(1, 0), R.at<double>(1, 1), R.at<double>(1, 2), t.at<double>(1, 0),
                         R.at<double>(2, 0), R.at<double>(2, 1), R.at<double>(2, 2), t.at<double>(2, 0));
    }
    return self;
}

- (void)dealloc {
    delete _K;
    delete _KInv;
}

#pragma mark - utility
- (void)setupK {
    _K = new cv::Mat((cv::Mat_<double>(3, 3) << 407.36, 0, 240,
                                                0, 723.71, 320,
                                                0,      0, 1));
    _KInv = new cv::Mat(_K->inv());
}

@end
