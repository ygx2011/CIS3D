//
//  CISGeometry.m
//  CIS3D
//
//  Created by Neo on 15/4/11.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISUtility.h"
#import "CISGeometry.h"

@interface CISGeometry ()

@end

@implementation CISGeometry

+ (cv::Mat)crossMatrix:(cv::Mat &)A {
    double x1 = A.at<double>(0, 0), x2 = A.at<double>(1, 0), x3 = A.at<double>(2, 0);
    cv::Mat Ax = (cv::Mat_<double>(3, 3) << 0, x3, -x2,
                                            -x3, 0, x1,
                                            x2, -x1, 0);
    return Ax;
}

+ (cv::Mat)iterativeTriangulationWithPoint1:(cv::Point2f)u1 camera1:(cv::Matx34d)P1
                                  andPoint2:(cv::Point2f)u2 camera2:(cv::Matx34d)P2 {
    const static int ITER_TIME = 10;
    const static double EPSILON = 1e-4;
    
    double w1 = 1, w2 = 1;
    cv::Mat_<double> X(4, 1);
    cv::Mat_<double> X_ = [CISGeometry triangulationWithPoint1:u1 camera1:P1
                                                     andPoint2:u2 camera2:P2];
    X(0) = X_(0); X(1) = X_(1); X(2) = X_(2); X(3) = 1.0;
    
    for (int i = 0; i < ITER_TIME; ++i) { //Hartley suggests 10 iterations at most
        //recalculate weights
        double p2x1 = cv::Mat_<double>(cv::Mat_<double>(P1).row(2)*X)(0);
        double p2x2 = cv::Mat_<double>(cv::Mat_<double>(P2).row(2)*X)(0);
        
        //breaking point
        if (fabs(w1 - p2x1) <= EPSILON && fabs(w2 - p2x2) <= EPSILON) break;
        w1 = p2x1; w2 = p2x2;
        
        //reweight equations and solve
        cv::Matx43d
        A((u1.x*P1(2, 0) - P1(0, 0)) / w1, (u1.x*P1(2, 1) - P1(0, 1)) / w1, (u1.x*P1(2, 2) - P1(0, 2)) / w1,
          (u1.y*P1(2, 0) - P1(1, 0)) / w1, (u1.y*P1(2, 1) - P1(1, 1)) / w1, (u1.y*P1(2, 2) - P1(1, 2)) / w1,
          (u2.x*P2(2, 0) - P2(0, 0)) / w2, (u2.x*P2(2, 1) - P2(0, 1)) / w2, (u2.x*P2(2, 2) - P2(0, 2)) / w2,
          (u2.y*P2(2, 0) - P2(1, 0)) / w2, (u2.y*P2(2, 1) - P2(1, 1)) / w2, (u2.y*P2(2, 2) - P2(1, 2)) / w2);
        
        cv::Mat_<double>
        B = (cv::Mat_<double>(4, 1) << -(u1.x*P1(2, 3) - P1(0, 3)) / w1,
                                       -(u1.y*P1(2, 3) - P1(1, 3)) / w1,
                                       -(u2.x*P2(2, 3) - P2(0, 3)) / w2,
                                       -(u2.y*P2(2, 3) - P2(1, 3)) / w2);
        
        solve(A, B, X_, cv::DECOMP_SVD);
        X(0) = X_(0); X(1) = X_(1); X(2) = X_(2); X(3) = 1.0;
    }
    return X;
}

+ (cv::Mat)triangulationWithPoint1:(cv::Point2f)u1 camera1:(cv::Matx34d)P1
                         andPoint2:(cv::Point2f)u2 camera2:(cv::Matx34d)P2 {

    cv::Matx43d A(u1.x*P1(2, 0) - P1(0, 0), u1.x*P1(2, 1) - P1(0, 1), u1.x*P1(2, 2) - P1(0, 2),
                  u1.y*P1(2, 0) - P1(1, 0), u1.y*P1(2, 1) - P1(1, 1), u1.y*P1(2, 2) - P1(1, 2),
                  u2.x*P2(2, 0) - P2(0, 0), u2.x*P2(2, 1) - P2(0, 1), u2.x*P2(2, 2) - P2(0, 2),
                  u2.y*P2(2, 0) - P2(1, 0), u2.y*P2(2, 1) - P2(1, 1), u2.y*P2(2, 2) - P2(1, 2));
    
    cv::Matx41d B(-(u1.x*P1(2, 3) - P1(0, 3)),
                  -(u1.y*P1(2, 3) - P1(1, 3)),
                  -(u2.x*P2(2, 3) - P2(0, 3)),
                  -(u2.y*P2(2, 3) - P2(1, 3)));
    
    cv::Mat_<double> X;
    cv::solve(A, B, X, cv::DECOMP_SVD);
    
    return X;
}

+ (void)decomposeEssentialMat:(cv::Mat &)E
                         ToR1:(cv::Mat &)R1 t1:(cv::Mat &)t1
                        andR2:(cv::Mat &)R2 t2:(cv::Mat &)t2 {
    cv::SVD svd(E);
    
    cv::Matx33d W(0, -1, 0,	//HZ 9.13
                  1, 0, 0,
                  0, 0, 1);
    cv::Matx33d Wt(0, 1, 0,
                   -1, 0, 0,
                   0, 0, 1);
    
    R1 = svd.u * cv::Mat(W)  * svd.vt; //HZ 9.19
    R2 = svd.u * cv::Mat(Wt) * svd.vt; //HZ 9.19
    t1 = svd.u.col(2); //u3
    t2 = - svd.u.col(2); //u3
}

@end
