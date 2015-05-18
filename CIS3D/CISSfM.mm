//
//  CISSfM.m
//  CIS3D
//
//  Created by Neo on 15/4/10.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISUtility.h"
#import "CISGeometry.h"
#import "CISSfM.h"
#import "CISImagePair.h"

@interface CISSfM ()

- (void)constructWithImagePair:(CISImagePair *)pair;
- (void)updateWithImagePair:(CISImagePair *)pair;

@end

@implementation CISSfM

@synthesize images            = _images;
@synthesize pairs             = _pairs;
@synthesize cloud             = _cloud;

#pragma mark - singleton method
+ (CISSfM *)sharedInstance {
    static CISSfM *singletonSfM = nil;
    
    static dispatch_once_t singleton;
    dispatch_once(&singleton, ^{
        NSLog(@"CISSfM: instantialized.");
        singletonSfM = [[CISSfM alloc] init];
    });
    
    return singletonSfM;
}

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _images = [[NSMutableArray alloc] init];
        _pairs  = [[NSMutableArray alloc] init];
        _cloud  = [[CISCloud alloc] init];
    }
    return self;
}

#pragma mark - update
- (void)addImage:(CISImage *)image {
    /* 完成特征提取以后，向ProcessImageViewController发布消息，更新ImageView */
    [[NSNotificationCenter defaultCenter] postNotificationName:CISImageAddedNotification
                                                        object:self
                                                      userInfo:@{CISImageAdded : image}];
    
    NSLog(@"CISSfM: %lu images in _image.", (unsigned long)[_images count]);
    NSLog(@"CISSfM: %lu pairs in _pair."  , (unsigned long)[_pairs count]);
    
    /* 队列没有图像，初始化 */
    if ([_images count] == 0) {
        [_images addObject:image];
    }
    else {
        /* 即使队列里已经有很多图像，有可能因为没有合适的图像对，仍然尚未开始重建。
         * 新图像 [暂时] 只与最后一个匹配 */
        [_images addObject:image];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CISImage *imageToMatch = [_images lastObject];
            CISImagePair *pair = [[CISImagePair alloc] initWithImage1:imageToMatch andImage2:image];

            if (pair.score) {
                if ([_pairs count] == 0) {
                    [self constructWithImagePair:pair];
                } else {
                    [self constructWithImagePair:pair];
                    //[self updateWithImagePair:pair];
                }
                [_pairs  addObject:pair];
                
                /* 完成Pair匹配以后，也向ProcessImageViewController发布消息，更新ImageView */
                [[NSNotificationCenter defaultCenter] postNotificationName:CISImagePairAddedNotification
                                                                    object:self
                                                                  userInfo:@{CISImagePairAdded : pair}];
            }
        });
    }
}

- (void)constructWithImagePair:(CISImagePair *)pair {
    int n = (int)pair.matchedPoints1->size();
    [[CISSfM sharedInstance].cloud clear];
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
    std::cout << "score: " << pair.score << std::endl;
}

@end
