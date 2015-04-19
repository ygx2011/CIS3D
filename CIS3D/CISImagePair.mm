//
//  CISImagePair.m
//  CIS3D
//
//  Created by Neo on 15/4/12.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISImagePair.h"

@interface CISImagePair ()

@property (nonatomic) std::vector<cv::Point2f> *keyPoints1;
@property (nonatomic) std::vector<cv::Point2f> *keyPoints2;

@end

@implementation CISImagePair

@synthesize image1         = _image1;
@synthesize image2         = _image2;

@synthesize matches        = _matches;
@synthesize fundamentalMat = _fundamentalMat;

@synthesize drawImage      = _drawImage;

@synthesize keyPoints1     = _keyPoints1;
@synthesize keyPoints2     = _keyPoints2;

#pragma mark - life cycle
- (instancetype)initWithImage1:(CISImage *)image1 andImage2:(CISImage *)image2 {
    self = [super init];
    if (self) {
        _image1 = image1;
        _image2 = image2;
        
        _matches = new std::vector<cv::DMatch>;
        cv::FlannBasedMatcher matcher;
        std::vector<std::vector<cv::DMatch> > knnMatches;
        
        _keyPoints1 = new std::vector<cv::Point2f>();
        _keyPoints2 = new std::vector<cv::Point2f>();

        matcher.knnMatch(*(_image1.keyDescriptor), *(_image2.keyDescriptor), knnMatches, 2);
        for (int i = 0; i < knnMatches.size(); ++i) {
            cv::DMatch best = knnMatches[i][0], good = knnMatches[i][1];
            if (best.distance < good.distance * KNN_THRESHOLD) {
                _matches->push_back(best);
                _keyPoints1->push_back((*_image1.keyPoints)[best.queryIdx].pt);
                _keyPoints2->push_back((*_image2.keyPoints)[best.trainIdx].pt);
            }
        }
        
        /* 四通道图片没法调用drawMatches，必须转换颜色 */
        cv::Mat __image1, __image2, __drawImage;
        cv::cvtColor(*_image1.image, __image1, CV_RGBA2RGB);
        cv::cvtColor(*_image2.image, __image2, CV_RGBA2RGB);
        
        cv::drawMatches(__image1, *_image1.keyPoints,
                        __image2, *_image2.keyPoints,
                        *_matches, __drawImage);
        
        _drawImage = new cv::Mat(__drawImage);
        
        /* 当两幅图完全不匹配时可能发生崩溃。此时不必计算 F */
        NSLog(@"CISImagePair: %lu matches in _matches", _matches->size());
        if (_matches->size() > MIN_MATCH_THRESHOLD) {
            _fundamentalMat = new cv::Mat(cv::findFundamentalMat(*_keyPoints1, *_keyPoints2));
            _image1.camera = [[CISCamera alloc] init];
            _image2.camera = [[CISCamera alloc] initWithFundamentalMat:_fundamentalMat];
            std::cout << "CISImagePair: _fundamentalMat = \n" << *_fundamentalMat << std::endl;
        }
        
        /* 然后算第二个CISImage的P，乘以猜的H */
        /* 然后三角化，算出初始的点云 */
        /* 然后 3D 到 2D */
    }
    return self;
}

- (void)dealloc {
    delete _matches;
    delete _fundamentalMat;
    
    delete _drawImage;
    
    delete _keyPoints1;
    delete _keyPoints2;
}

@end
