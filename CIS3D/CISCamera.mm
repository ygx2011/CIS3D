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

static cv::Mat *sharedK, *sharedKInv;

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
    }
    return self;
}

- (void)setPWithR:(cv::Mat)R andT:(cv::Mat)t {
    _P = [CISGeometry pFromR:R andT:t];
}

- (void)setPWithId {
    _P = cv::Matx34d(1, 0, 0, 0,
                     0, 1, 0, 0,
                     0, 0, 1, 0);
}

#pragma mark - utility
- (void)setupK {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedK = new cv::Mat((cv::Mat_<double>(3, 3) << 407.36, 0, 240,
                                                         0, 723.71, 320,
                                                         0,      0, 1));
        sharedKInv = new cv::Mat(sharedK->inv());
    });
    _K = sharedK;
    _KInv = sharedKInv;
}

+ (void)dealloc {
    delete sharedK;
    delete sharedKInv;
}

@end
