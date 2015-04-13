//
//  CISSfM.m
//  CIS3D
//
//  Created by Neo on 15/4/10.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISSfM.h"

@interface CISSfM ()

- (void)didReceiveImageAddedNotification:(NSNotification *)notification;

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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveImageAddedNotification:)
                                                     name:CISImageAddedNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - update when a new image comes in
- (void)didReceiveImageAddedNotification:(NSNotification *)notification {
    CISImage *image = [[notification userInfo] objectForKey:CISImageAdded];
    switch ([_images count]) {
        case 0: break;
        case 1: {
            CISImagePair *imagePair = [[CISImagePair alloc] initWithImage1:[_images objectAtIndex:0]
                                                                 andImage2:image];
            [_pairs addObject:imagePair];
            break;
        }
        default: {
            break;
        }
    }
    [_images addObject:image];
}

@end
