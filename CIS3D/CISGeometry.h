//
//  CISGeometry.h
//  CIS3D
//
//  Created by Neo on 15/4/11.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <opencv2/opencv.hpp>

@interface CISGeometry : NSObject

/* 只有在运算过程中会用到关于Mat的辅助函数，才储存成变量形式；
 * 作为接口的Mat，全都储存成指针。 */
+ (cv::Mat)crossMatrix:(cv::Mat &)A;
+ (cv::Point2f)reprojectPoint:(cv::Point2f)u withKInv:(cv::Mat *)KInv;

+ (cv::Mat)iterativeTriangulationWithPoint1:(cv::Point2f)u1 camera1:(cv::Matx34d)P1
                                  andPoint2:(cv::Point2f)u2 camera2:(cv::Matx34d)P2;

+ (cv::Mat)triangulationWithPoint1:(cv::Point2f)u1 camera1:(cv::Matx34d)P1
                         andPoint2:(cv::Point2f)u2 camera2:(cv::Matx34d)P2;

+ (void)decomposeEssentialMat:(cv::Mat &)E
                         ToR1:(cv::Mat &)R1 t1:(cv::Mat &)t1
                        andR2:(cv::Mat &)R2 t2:(cv::Mat &)t2;

@end
