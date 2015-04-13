//
//  CISImagePair.m
//  CIS3D
//
//  Created by Neo on 15/4/12.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISImagePair.h"

@implementation CISImagePair

@synthesize matches = _matches;
@synthesize image1  = _image1;
@synthesize image2  = _image2;

#pragma mark - life cycle
- (instancetype)initWithImage1:(CISImage *)image1 andImage2:(CISImage *)image2 {
    self = [super init];
    if (self) {
        _image1 = image1;
        _image2 = image2;
        
        _matches = new std::vector<cv::DMatch>;
        cv::FlannBasedMatcher matcher;
        std::vector<std::vector<cv::DMatch> > knnMatches;
        matcher.knnMatch(*(image1.keyDescriptor), *(image2.keyDescriptor), knnMatches, 2);
        for (int i = 0; i < knnMatches.size(); ++i) {
            cv::DMatch best = knnMatches[i][0], good = knnMatches[i][1];
            if (best.distance < good.distance * KNN_THRESHOLD) {
                _matches->push_back(best);
            }
        }
    }
    return self;
}

- (void)dealloc {
    delete _matches;
}

@end
