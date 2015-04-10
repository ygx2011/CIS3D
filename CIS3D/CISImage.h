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

@interface CISImage : NSObject

@property(nonatomic) cv::Mat                   image;
@property(nonatomic) cv::Mat                   keyDescriptor;
@property(nonatomic) std::vector<cv::KeyPoint> keyPoints;

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(cv::Mat &)cvMat;

- (void)initWithUIImage:(UIImage *)image;

@end
