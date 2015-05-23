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
#import "CISSfM+Update.h"
#import "CISImagePair.h"

@interface CISSfM ()

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
        NSLog(@"%@: instantialized.", self.class);
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
    
    NSLog(@"%@: %lu images in _image.",self.class, (unsigned long)[_images count]);
    NSLog(@"%@: %lu pairs in _pair."  ,self.class, (unsigned long)[_pairs count]);
    
    /* 队列没有图像，初始化 */
    if ([_images count] == 0) {
        [_images addObject:image];
    }
    else {
        /* 即使队列里已经有很多图像，有可能因为没有合适的图像对，仍然尚未开始重建。
         * 新图像 [暂时] 只与最后几个匹配 */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int begin = (int)([_images count] - SEARCH_WINDOW);
            int end   = (int)([_images count]);
            begin = begin > 0 ? begin : 0;
            
            float maxScore = 0.0f;
            CISImagePair *selectedPair = nil;
            
            for (int i = begin; i < end; ++i) {
                /* 选取得分最高且在队列里最靠后的 (故用 >=) */
                CISImage *imageToMatch = [_images objectAtIndex:i];
                CISImagePair *pair = [[CISImagePair alloc] initWithImage1:imageToMatch andImage2:image];
                if (pair.score >= maxScore) {
                    maxScore = pair.score;
                    selectedPair = pair;
                }
            }
            
            /* 计算完毕后返回主线程 */
            dispatch_async(dispatch_get_main_queue(), ^{
            if (maxScore) {
                BOOL isSucceeded;
                if ([_pairs count] == 0) {
                    isSucceeded = [self constructWithImagePair:selectedPair];
                } else {
                    isSucceeded = [self updateWithImagePair:selectedPair];
                }
                if (! isSucceeded) return;
                [_images addObject:image];
                [_pairs  addObject:selectedPair];
                /* 完成Pair匹配以后，也向ProcessImageViewController发布消息，更新ImageView */
                [[NSNotificationCenter defaultCenter] postNotificationName:CISImagePairAddedNotification
                                                                    object:self
                                                                  userInfo:@{CISImagePairAdded : selectedPair}];
            }/* if */} /* async-main */);
        });
    }
}

@end
