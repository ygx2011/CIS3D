//
//  CISSfM+Update.m
//  CIS3D
//
//  Created by Neo on 15/5/19.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISUtility.h"
#import "CISGeometry.h"
#import "CISSfM.h"
#import "CISSfM+Update.h"

@implementation CISSfM (Update)

- (void)constructWithImagePair:(CISImagePair *)pair {
    NSLog(@"Constructing ...");
    int n = (int)pair.matchedPoints1->size();
    [[CISSfM sharedInstance].cloud clear];
    
    pair.image1.camera = [[CISCamera alloc] init];
    pair.image2.camera = [[CISCamera alloc] initWithFundamentalMat:pair.fundamentalMat];
    
    for (int i = 0; i < n; ++i) {
        cv::Point2f pt1 = (*pair.matchedPoints1)[i], pt2 = (*pair.matchedPoints2)[i];
        
        /* 首先将二维点乘以内参的逆，矫正回世界坐标系屏幕上的成像点坐标 */
        cv::Point2f rectifiedPt1 = [CISGeometry rectifyPoint:pt1
                                                    withKInv:pair.image1.camera.KInv];
        cv::Point2f rectifiedPt2 = [CISGeometry rectifyPoint:pt2
                                                    withKInv:pair.image2.camera.KInv];
        
        /* 三角化得到三维点 */
        cv::Mat point3dim =
        [CISGeometry iterativeTriangulationWithPoint1:rectifiedPt1 camera1:pair.image1.camera.P
                                            andPoint2:rectifiedPt2 camera2:pair.image2.camera.P];
        //std::cout << point3dim << std::endl;
        
        int x = (int)pt1.x, y = (int)pt1.y;
        [[CISSfM sharedInstance].cloud addPointWithX:point3dim.at<double>(0, 0)
                                                   Y:point3dim.at<double>(1, 0)
                                                   Z:point3dim.at<double>(2, 0)
                                                AndR:(pair.image1.image->at<cv::Vec4b>(y, x)[0] / 255.0f)
                                                   G:(pair.image1.image->at<cv::Vec4b>(y, x)[1] / 255.0f)
                                                   B:(pair.image1.image->at<cv::Vec4b>(y, x)[2] / 255.0f)];
        
        /* 将二维点与三维点建立联系 */
        int indexOf3DPt = [[CISSfM sharedInstance].cloud count];
        (*pair.image1.keyPointTo3DIndex)[(*pair.matchedPointsIndex1)[i]] = indexOf3DPt;
        (*pair.image2.keyPointTo3DIndex)[(*pair.matchedPointsIndex2)[i]] = indexOf3DPt;
    }
}



- (void)updateWithImagePair:(CISImagePair *)pair {
    int n = (int)pair.matchedPoints1->size();
    std::cout << "score: " << pair.score << std::endl;
}

@end
