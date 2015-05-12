//
//  CISImagePair.h
//  CIS3D
//
//  Created by Neo on 15/4/12.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <opencv2/opencv.hpp>

#import "CISImage.h"

@interface CISImagePair : NSObject

@property (nonatomic) double                   score;
@property (nonatomic) CISImage                *image1;
@property (nonatomic) CISImage                *image2;

@property (nonatomic) std::vector<cv::DMatch> *matches;
@property (nonatomic) cv::Mat                 *fundamentalMat;

@property (nonatomic) std::vector<cv::Point2f> *matchedPoints1;
@property (nonatomic) std::vector<cv::Point2f> *matchedPoints2;
@property (nonatomic) std::vector<int>         *matchedPointsIndex1;
@property (nonatomic) std::vector<int>         *matchedPointsIndex2;

- (instancetype)initWithImage1:(CISImage *)image1 andImage2:(CISImage *)image2;
- (cv::Mat)drawMatches;

@end
