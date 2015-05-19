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

#pragma mark - utility function
- (void)triangulationWithPoint1:(cv::Point2f)pt1 inImage1:(CISImage *)image1
                      andPoint2:(cv::Point2f)pt2 inImage2:(CISImage *)image2 {
    
    /* 首先将二维点乘以内参的逆，矫正回世界坐标系屏幕上的成像点坐标 */
    cv::Point2f rectifiedPt1 = [CISGeometry rectifyPoint:pt1
                                                withKInv:image1.camera.KInv];
    cv::Point2f rectifiedPt2 = [CISGeometry rectifyPoint:pt2
                                                withKInv:image2.camera.KInv];
    
    /* 三角化得到三维点 */
    cv::Mat pt3dim =
    [CISGeometry iterativeTriangulationWithPoint1:rectifiedPt1 camera1:image1.camera.P
                                        andPoint2:rectifiedPt2 camera2:image2.camera.P];
    
    int x = (int)pt1.x, y = (int)pt1.y;
    [[CISSfM sharedInstance].cloud addPointWithX:pt3dim.at<double>(0, 0)
                                               Y:pt3dim.at<double>(1, 0)
                                               Z:pt3dim.at<double>(2, 0)
                                            AndR:(image1.image->at<cv::Vec4b>(y, x)[0] / 255.0f)
                                               G:(image1.image->at<cv::Vec4b>(y, x)[1] / 255.0f)
                                               B:(image1.image->at<cv::Vec4b>(y, x)[2] / 255.0f)];
}

- (void)constructWithImagePair:(CISImagePair *)pair {
    NSLog(@"%@: Constructing ...", self.class);
    int n = (int)pair.matchedPoints1->size();
    [[CISSfM sharedInstance].cloud clear];
    
    pair.image1.camera = [[CISCamera alloc] init];
    pair.image2.camera = [[CISCamera alloc] initWithFundamentalMat:pair.fundamentalMat];
    
    for (int i = 0; i < n; ++i) {
        cv::Point2f pt1 = (*pair.matchedPoints1)[i], pt2 = (*pair.matchedPoints2)[i];
        /* 从二维点恢复出三维点 */
        [self triangulationWithPoint1:pt1 inImage1:pair.image1
                            andPoint2:pt2 inImage2:pair.image2];
        
        /* 将二维点与三维点建立联系 */
        int indexOf3DPt = [[CISSfM sharedInstance].cloud count] - 1;
        (*pair.image1.keyPointTo3DIndex)[(*pair.matchedPointsIndex1)[i]] = indexOf3DPt;
        (*pair.image2.keyPointTo3DIndex)[(*pair.matchedPointsIndex2)[i]] = indexOf3DPt;
    }
}

- (void)updateWithImagePair:(CISImagePair *)pair {
    NSLog(@"%@: Updating ...", self.class);
    std::vector<cv::Point3f> vec3dim;
    std::vector<cv::Point2f> vec2dim;
    int n = (int)pair.matchedPoints1->size();
    
    /* 建立3D点和新视图中2D点的关系 */
    for (int i = 0; i < n; ++i) {
        int index3dim = (*pair.image1.keyPointTo3DIndex)[(*pair.matchedPointsIndex1)[i]];
        NSLog(@"%d %d", i, index3dim);
        if (index3dim != -1) {
            cv::Point2f pt2dim = (*pair.matchedPoints2)[i];
            
            vec3dim.push_back([[CISSfM sharedInstance].cloud pointAtIndex:index3dim]);
            vec2dim.push_back(cv::Point2f(pt2dim.x, IMG2WLD(pt2dim.y)));
        }
    }
    
    /* 计算出重投影后新视图的的[R | t] */
    if (vec3dim.size() > MIN_2D_3D_MATCH_THRESHOLD) {
        cv::Mat R, r, t;
        
        cv::solvePnPRansac(vec3dim, vec2dim,
                           *pair.image1.camera.K, cv::Mat_<double>::zeros(1, 4),
                           r, t);
        cv::Rodrigues(r, R);
        pair.image2.camera = [[CISCamera alloc] initWithR:R andT:t];
        
        /* 利用新视图的[R | t]进行三角化计算 */
        for (int i = 0; i < n; ++i) {
            cv::Point2f pt1 = (*pair.matchedPoints1)[i], pt2 = (*pair.matchedPoints2)[i];
            /* 从二维点恢复出三维点 */
            [self triangulationWithPoint1:pt1 inImage1:pair.image1
                                andPoint2:pt2 inImage2:pair.image2];
            
            /* 将二维点与三维点建立联系 */
            int indexOf3DPt = [[CISSfM sharedInstance].cloud count] - 1;
            (*pair.image1.keyPointTo3DIndex)[(*pair.matchedPointsIndex1)[i]] = indexOf3DPt;
            (*pair.image2.keyPointTo3DIndex)[(*pair.matchedPointsIndex2)[i]] = indexOf3DPt;
        }
    }
}

@end
