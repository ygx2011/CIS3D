//
//  CISImage.h
//  CIS3D
//
//  Created by Neo on 15/4/10.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <opencv2/opencv.hpp>
#import <vector>

#import "CISConsts.h"
#import "CISCamera.h"

@interface CISImage : NSObject

@property(nonatomic) cv::Mat*                   image;
@property(atomic)    cv::Mat*                   keyDescriptor;
@property(atomic)    std::vector<cv::KeyPoint>* keyPoints;
@property(nonatomic, strong) CISCamera*         camera;

+ (cv::Mat *)cvMatFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(cv::Mat &)cvMat;

- (void)initWithUIImage:(UIImage *)image;

@end
