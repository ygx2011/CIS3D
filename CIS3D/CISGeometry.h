//
//  CISGeometry.h
//  CIS3D
//
//  Created by Neo on 15/4/11.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <opencv2/opencv.hpp>

#import "CISUtility.h"

@interface CISGeometry : NSObject

/* 只有在运算过程中会用到关于Mat的辅助函数，才储存成变量形式；
 * 作为接口的Mat，全都储存成指针。 */
+ (cv::Mat)crossMatrix:(cv::Mat &)A;

@end
