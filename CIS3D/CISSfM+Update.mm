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

#pragma mark - @override of triangulations
- (cv::Point3f)triangulationWithPoint1:(cv::Point2f)u1 inImage1:(CISImage *)image1
                             andPoint2:(cv::Point2f)u2 inImage2:(CISImage *)image2 {
    
    /* 首先将二维点乘以内参的逆，矫正回世界坐标系屏幕上的成像点坐标 */
    cv::Point2f x1 = [CISGeometry xFromU:u1 withKInv:*(image1.camera.KInv)];
    cv::Point2f x2 = [CISGeometry xFromU:u2 withKInv:*(image2.camera.KInv)];
    
    /* 三角化得到三维点 */
    cv::Point3f X = [CISGeometry iterativeTriangulationWithPoint1:x1 forP1:image1.camera.P
                                                        andPoint2:x2 forP2:image2.camera.P];
    return X;
}

- (void)triangulationForAllPointsInPair:(CISImagePair *)pair {
    int n = (int)pair.matchedPoints1->size();
    
    /* 对所有点做三角化 */
    for (int i = 0; i < n; ++i) {
        cv::Point2f u1 = (*pair.matchedPoints1)[i], u2 = (*pair.matchedPoints2)[i];
        /* 从二维点恢复出三维点 */
        cv::Point3f X = [self triangulationWithPoint1:u1 inImage1:pair.image1
                                            andPoint2:u2 inImage2:pair.image2];
        
        /* 将三维点加入点云中 */
        cv::Vec4b rgba = (pair.image1.image->at<cv::Vec4b>((int)u1.y, (int)u1.x));
        [[CISSfM sharedInstance].cloud addPointWithX:X.x Y:X.y Z:X.z
                                                AndR:rgba[0]/255.0 G:rgba[1]/255.0 B:rgba[2]/255.0];
        
        /* 将二维点与三维点建立联系 */
        int Xindex = [[CISSfM sharedInstance].cloud count] - 1;
        (*pair.image1.keyPointTo3DIndex)[(*pair.matchedPointsIndex1)[i]] = Xindex;
        (*pair.image2.keyPointTo3DIndex)[(*pair.matchedPointsIndex2)[i]] = Xindex;
    }
}

#pragma mark - choose of R t
- (BOOL)correctR:(cv::Mat &)R0 t:(cv::Mat &)t0
            inRs:(cv::Mat[2])R ts:(cv::Mat[2])t
         forPair:(CISImagePair *)pair {
    int n = (int)pair.matchedPoints1->size();
    
    int atFront[2] = {0};
    /* 测试四种情况 */
    for (int cases = 0; cases < 4; ++cases) {
        atFront[0] = atFront[1] = 0;
        
        cv::Mat _R_(R[cases / 2].t()), _t_(- _R_ * t[cases % 2]);
        [pair.image1.camera setPWithId];
        [pair.image2.camera setPWithR:R[cases / 2] andT:t[cases % 2]];

        /* 首先生成点云 */
        for (int i = 0; i < n; ++i) {
            cv::Point2f u1 = (*pair.matchedPoints1)[i], u2 = (*pair.matchedPoints2)[i];
            cv::Point3f X = [self triangulationWithPoint1:u1 inImage1:pair.image1
                                                andPoint2:u2 inImage2:pair.image2];
            /* 在相机0的前方 */
            cv::Point3f _u1_ = X;
            cv::Point3f _u2_ = [CISGeometry reprojectX:X withR:_R_ andT:_t_];

            if (_u1_.z > 0) { atFront[0] ++; }
            if (_u2_.z > 0) { atFront[1] ++; }
        }
        std::cout << "Case: " << cases << std::endl
        << (atFront[0] / (float)n) << std::endl
        << (atFront[1] / (float)n) << std::endl;
        if ((atFront[0] / (float)n) >= FRONT_THRESHOLD_RATIO
         && (atFront[1] / (float)n) >= FRONT_THRESHOLD_RATIO) {
            R0 = R[cases / 2], t0 = t[cases % 2];
            return YES;
        }
    }
    return NO;
}

#pragma mark - constructing
- (BOOL)constructWithImagePair:(CISImagePair *)pair {
    NSLog(@"%@: Constructing ...", self.class);
    [[CISSfM sharedInstance].cloud clear];
    
    cv::Mat *K = pair.image1.camera.K;
    cv::Mat E = K->t() * (*pair.fundamentalMat) * (*K);
    cv::Mat R[2], t[2], R0, t0;
    [CISGeometry decomposeEssentialMat:E ToR1:R[0] t1:t[0]
                                        andR2:R[1] t2:t[1]];
    /* 旋转矩阵行列式必为1， 如果是-1，需要重新分解E */
    if ((fabs(cv::determinant(R[0]) + 1)) < 1e-6) {
        E = -E;
        [CISGeometry decomposeEssentialMat:E ToR1:R[0] t1:t[0]
                                     andR2:R[1] t2:t[1]];
    }

    BOOL isRecovered = [self correctR:R0 t:t0
                                 inRs:R  ts:t
                              forPair:pair];
    if (!isRecovered) return NO;

    [pair.image1.camera setPWithId];
    [pair.image2.camera setPWithR:R0 andT:t0];
    
    [self triangulationForAllPointsInPair:pair];
    return YES;
}

#pragma mark - updating
- (BOOL)updateWithImagePair:(CISImagePair *)pair {
    NSLog(@"%@: Updating ...", self.class);
    std::vector<cv::Point3f> Xs;
    std::vector<cv::Point2f> us;
    int n = (int)pair.matchedPoints1->size();
    
    /* 建立3D点和新视图中2D点的关系 */
    for (int i = 0; i < n; ++i) {
        int Xindex = (*pair.image1.keyPointTo3DIndex)[(*pair.matchedPointsIndex1)[i]];
        if (Xindex != -1) {
            cv::Point2f u2 = (*pair.matchedPoints2)[i];
            Xs.push_back([[CISSfM sharedInstance].cloud pointAtIndex:Xindex]);
            us.push_back(cv::Point2f(u2.x, IMG2WLD(u2.y)));
        }
    }
    
    /* 计算出重投影后新视图的的[R | t] */
    if (Xs.size() < MIN_2D_3D_MATCH_THRESHOLD) {
        return NO;
    }
    
    /* 生成新的三维点 */
    cv::Mat R, r, t;
    cv::solvePnPRansac(Xs, us,
                       *pair.image1.camera.K, cv::Mat_<double>::zeros(1, 4),
                       r, t);
    cv::Rodrigues(r, R);
    [pair.image2.camera setPWithR:R andT:t];
    
    [self triangulationForAllPointsInPair:pair];
    return YES;
}

@end
