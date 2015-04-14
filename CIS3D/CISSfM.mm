//
//  CISSfM.m
//  CIS3D
//
//  Created by Neo on 15/4/10.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISSfM.h"

@interface CISSfM ()

- (void)constructWithImagePair:(CISImagePair *)pair;
- (void)updateWithImagePair:(CISImagePair *)pair;

@end

@implementation CISSfM

@synthesize images = _images;
@synthesize pairs  = _pairs;
@synthesize cloud  = _cloud;

#pragma mark - singleton method
+ (CISSfM *)sharedInstance {
    static CISSfM *singletonSfM = nil;

    static dispatch_once_t singleton;
    dispatch_once(&singleton, ^{
#ifdef LOG
        NSLog(@"CISSfM: instantialized.");
#endif
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
#ifdef LOG
    NSLog(@"CISSfM: %lu images in _image.", (unsigned long)[_images count]);
    NSLog(@"CISSfM: %lu pairs in _pair."  , (unsigned long)[_pairs count]);
#endif
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
