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
- (instancetype)initWithFundamentalMat:(cv::Mat *)F andIntrinsicMat:(cv::Mat *)K {
    self = [super init];
    if (self) {
        _K = K;
        _KInv = new cv::Mat(K->inv());

        cv::Mat E = K->t() * (*F) * (*K);
        cv::Mat R1, t1, R2, t2;
        /* R2, t2备用，可能需要选择矩阵 */
        [CISGeometry decomposeEssentialMat:E ToR1:R1 t1:t1 andR2:R2 t2:t2];

        _P = cv::Matx34d(R1.at<double>(0, 0), R1.at<double>(0, 1), R1.at<double>(0, 2), t1.at<double>(0, 0),
                         R1.at<double>(1, 0), R1.at<double>(1, 1), R1.at<double>(1, 2), t1.at<double>(1, 0),
                         R1.at<double>(2, 0), R1.at<double>(2, 1), R1.at<double>(2, 2), t1.at<double>(2, 0));
    }
    return self;
}

- (instancetype)initWithIntrinsicMat:(cv::Mat *)K {
    self = [super init];
    if (self) {
        _K = K;
        _KInv = new cv::Mat(K->inv());

        _P = cv::Matx34d(1, 0, 0, 0,
                         0, 1, 0, 0,
                         0, 0, 1, 0);
    }
    return self;
}

#pragma mark - deprecated
/* 在一个CISImagePair中，图像2由此method初始化，是相差一个 H 的 K [R | t] */
- (instancetype)initWithFundamentalMat:(cv::Mat *)F {
    self = [super init];
    if (self) {
        cv::SVD svd(*F);
        
        cv::Mat e = svd.u.col(2);
        cv::Mat tmp = -1 * [CISGeometry crossMatrix:e] * (*F);
        double w = tmp.at<double>(2, 2);
        _P =
        cv::Matx34d(tmp.at<double>(0, 0)/w, tmp.at<double>(0, 1)/w, tmp.at<double>(0, 2)/w, e.at<double>(0, 0)/w,
                    tmp.at<double>(1, 0)/w, tmp.at<double>(1, 1)/w, tmp.at<double>(1, 2)/w, e.at<double>(1, 0)/w,
                    tmp.at<double>(2, 0)/w, tmp.at<double>(2, 1)/w, tmp.at<double>(2, 2)/w, e.at<double>(2, 0)/w);
    }
    return self;
}

/* 图像1由此初始化，是默认的 [I | 0] */
- (instancetype)init {
    self = [super init];
    if (self) {
        _P = cv::Matx34d(1, 0, 0, 0,
                         0, 1, 0, 0,
                         0, 0, 1, 0);
    }
    return self;
}

- (void)dealloc {
    delete _K;
    delete _KInv;
}

@end
