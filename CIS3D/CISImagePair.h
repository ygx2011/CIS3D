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
#import "CISConsts.h"

@interface CISImagePair : NSObject

@property(nonatomic) std::vector<cv::DMatch> *matches;
@property(nonatomic) CISImage                *image1;
@property(nonatomic) CISImage                *image2;

- (instancetype)initWithImage1:(CISImage *)image1 andImage2:(CISImage *)image2;

@end
