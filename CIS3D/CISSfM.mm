//
//  CISSfM.m
//  CIS3D
//
//  Created by Neo on 15/4/10.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISUtility.h"
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
        [_cloud addPointWithX:1.0f Y:1.5f Z:0.0f
                         AndR:1.0f G:0.0f B:0.0f];
        [_cloud addPointWithX:-1.0f Y:1.5f Z:0.0f
                         AndR:1.0f G:0.0f B:0.0f];

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
}

- (void)updateWithImagePair:(CISImagePair *)pair {
}

@end
