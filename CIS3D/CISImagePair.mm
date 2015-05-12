//
//  CISImagePair.m
//  CIS3D
//
//  Created by Neo on 15/4/12.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <iostream>

#import "CISUtility.h"
#import "CISSfM.h"
#import "CISGeometry.h"
#import "CISImagePair.h"

@interface CISImagePair ()

@end

@implementation CISImagePair

@synthesize score          = _score;

@synthesize image1         = _image1;
@synthesize image2         = _image2;

@synthesize matches        = _matches;
@synthesize fundamentalMat = _fundamentalMat;

@synthesize drawImage      = _drawImage;

@synthesize keyPoints1     = _keyPoints1;
@synthesize keyPoints2     = _keyPoints2;

@synthesize keyPointsIndex1 = _keyPointsIndex1;
@synthesize keyPointsIndex2 = _keyPointsIndex2;

#pragma mark - life cycle
- (instancetype)initWithImage1:(CISImage *)image1 andImage2:(CISImage *)image2 {
    self = [super init];
    if (self) {
        _score = 0.0f;
        
        _image1 = image1;
        _image2 = image2;
        
        _matches = new std::vector<cv::DMatch>;
        cv::FlannBasedMatcher matcher;
        std::vector<std::vector<cv::DMatch> > knnMatches;
        
        _keyPoints1 = new std::vector<cv::Point2f>();
        _keyPoints2 = new std::vector<cv::Point2f>();
        _keyPointsIndex1 = new std::vector<int>();
        _keyPointsIndex2 = new std::vector<int>();

        /* 寻找两图匹配点 */
        matcher.knnMatch(*(_image1.keyDescriptor), *(_image2.keyDescriptor), knnMatches, 2);
        for (int i = 0; i < knnMatches.size(); ++i) {
            cv::DMatch best = knnMatches[i][0], good = knnMatches[i][1];
            if (best.distance < good.distance * KNN_THRESHOLD) {
                _matches->push_back(best);
                
                _keyPointsIndex1->push_back(best.queryIdx);
                _keyPoints1->push_back((*_image1.keyPoints)[best.queryIdx].pt);
                
                _keyPointsIndex2->push_back(best.trainIdx);
                _keyPoints2->push_back((*_image2.keyPoints)[best.trainIdx].pt);
            }
        }
        
        /* 绘制两图对应关系。四通道图片没法调用drawMatches，必须转换颜色 */
        cv::Mat __image1, __image2, __drawImage;
        cv::cvtColor(*_image1.image, __image1, CV_RGBA2RGB);
        cv::cvtColor(*_image2.image, __image2, CV_RGBA2RGB);
        
        cv::drawMatches(__image1, *_image1.keyPoints,
                        __image2, *_image2.keyPoints,
                        *_matches, __drawImage);
        
        _drawImage = new cv::Mat(__drawImage);
        
        /* 计算F，恢复摄像机矩阵。当两幅图完全不匹配时可能发生崩溃。此时不必计算 F */
        NSLog(@"CISImagePair: %lu matches in _matches", _matches->size());
        if (_matches->size() > MIN_MATCH_THRESHOLD) {
            /* 由对应点得到基础矩阵 */
            cv::Mat filter;
            _fundamentalMat =
            new cv::Mat(cv::findFundamentalMat(*_keyPoints1,
                                               *_keyPoints2,
                                               cv::FM_RANSAC,
                                               3.0,
                                               0.99,
                                               filter));
            std::cout << "Filter: " << filter << std::endl;
            std::cout << "CISImagePair: _fundamentalMat = \n" << *_fundamentalMat << std::endl;

            _image1.camera = [[CISCamera alloc] init];
            _image2.camera = [[CISCamera alloc] initWithFundamentalMat:_fundamentalMat];
            std::cout << "CISImagePair: _image1s P = \n" << _image1.camera.P << std::endl;
            std::cout << "CISImagePair: _image2s P = \n" << _image2.camera.P << std::endl;
        }
    }
    return self;
}

- (void)dealloc {
    delete _matches;
    delete _fundamentalMat;
    
    delete _drawImage;
    
    delete _keyPoints1;
    delete _keyPoints2;
    
    delete _keyPointsIndex1;
    delete _keyPointsIndex2;
}

@end
