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
    
    switch ([_images count]) {
        case 0: {
            [_images addObject:image];
            break;
        }
        case 1: {
            /* 队列里只存储了一个图像时，新图像与之匹配 */
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CISImage *imageToMatch = [_images firstObject];
                CISImagePair *pair = [[CISImagePair alloc] initWithImage1:imageToMatch andImage2:image];
                
                [self constructWithImagePair:pair];
                [_images addObject:image];
                [_pairs  addObject:pair];

                /* 完成Pair匹配以后，也向ProcessImageViewController发布消息，更新ImageView */
                [[NSNotificationCenter defaultCenter] postNotificationName:CISImagePairAddedNotification
                                                                    object:self
                                                                  userInfo:@{CISImagePairAdded : pair}];
            });
            break;
        }
        default: {
            /* 队列里已经有很多图像时，新图像 [暂时] 只与最后一个匹配 */
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CISImage *imageToMatch = [_images lastObject];
                CISImagePair *pair = [[CISImagePair alloc] initWithImage1:imageToMatch andImage2:image];
                
                [self updateWithImagePair:pair];
                [_images addObject:image];
                [_pairs  addObject:pair];
                
                /* 完成Pair匹配以后，也向ProcessImageViewController发布消息，更新ImageView */
                [[NSNotificationCenter defaultCenter] postNotificationName:CISImagePairAddedNotification
                                                                    object:self
                                                                  userInfo:@{CISImagePairAdded : pair}];
            });
            break;
        }
    }
}

- (void)constructWithImagePair:(CISImagePair *)pair {
    int n = (int)pair.keyPoints1->size();
    [[CISSfM sharedInstance].cloud clear];
    for (int i = 0; i < n; ++i) {
        /* 首先将二维点 homo 化 */
        cv::Mat rectifiedPt1 = cv::Mat((cv::Mat_<double>(3, 1) <<
                                        (*pair.keyPoints1)[i].x, (*pair.keyPoints1)[i].y, 1.0));
        cv::Mat rectifiedPt2 = cv::Mat((cv::Mat_<double>(3, 1) <<
                                        (*pair.keyPoints2)[i].x, (*pair.keyPoints2)[i].y, 1.0));
        
        /* 乘以内参的逆，消除投影变换，返回到世界坐标系成像平面上的2D坐标 */
        rectifiedPt1 = (*pair.image1.camera.KInv) * rectifiedPt1;
        rectifiedPt2 = (*pair.image2.camera.KInv) * rectifiedPt2;
        cv::Point2f pt1 = cv::Point2f(rectifiedPt1.at<double>(0, 0) / rectifiedPt1.at<double>(2, 0),
                                      rectifiedPt1.at<double>(1, 0) / rectifiedPt1.at<double>(2, 0));
        cv::Point2f pt2 = cv::Point2f(rectifiedPt2.at<double>(0, 0) / rectifiedPt2.at<double>(2, 0),
                                      rectifiedPt2.at<double>(1, 0) / rectifiedPt2.at<double>(2, 0));
        
        /* 三角化得到三维点 */
        cv::Mat point3dim =
        [CISGeometry iterativeTriangulationWithPoint1:pt1 camera1:pair.image1.camera.P
                                            andPoint2:pt2 camera2:pair.image2.camera.P];
        //std::cout << point3dim << std::endl;
        
        int x = (int)(*pair.keyPoints1)[i].x, y = (int)(*pair.keyPoints2)[i].y;
        [[CISSfM sharedInstance].cloud addPointWithX:point3dim.at<double>(0, 0)
                                                   Y:point3dim.at<double>(1, 0)
                                                   Z:point3dim.at<double>(2, 0)
                                                AndR:(pair.image1.image->at<cv::Vec4b>(y, x)[0] / 255.0f)
                                                   G:(pair.image1.image->at<cv::Vec4b>(y, x)[1] / 255.0f)
                                                   B:(pair.image1.image->at<cv::Vec4b>(y, x)[2] / 255.0f)];
        
        /* 将二维点与三维点建立联系 */
        int indexOf3DPt = [[CISSfM sharedInstance].cloud count];
        (*pair.image1.correspondenceTo3DIndex)[(*pair.keyPointsIndex1)[i]] = indexOf3DPt;
        (*pair.image2.correspondenceTo3DIndex)[(*pair.keyPointsIndex2)[i]] = indexOf3DPt;
    }
}

- (void)updateWithImagePair:(CISImagePair *)pair {
    std::cout << "score: " << pair.score << std::endl;
}

@end
