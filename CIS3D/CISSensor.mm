//
//  CISSensor.m
//  CIS3D
//
//  Created by Neo on 15/4/17.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISSensor.h"
#import <CoreMotion/CoreMotion.h>

@interface CISSensor()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation CISSensor

@synthesize motionManager = _motionManager;

+ (CISSensor *)sharedInstance {
    static CISSensor *singletonSensor;
    
    static dispatch_once_t singleton;
    dispatch_once(&singleton, ^{
        singletonSensor = [[CISSensor alloc] init];
    });
    
    return singletonSensor;
}

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (void)start {
    [self startAccelerator];
    [self startGyroscope];
}

- (void)stop {
    [self stopAccelerator];
    [self stopGyroscope];
}

- (void)startAccelerator {
    if ([_motionManager isAccelerometerAvailable]){
        NSLog(@"Accelerometer is available.");
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [_motionManager startAccelerometerUpdatesToQueue:queue
                                             withHandler:
         ^(CMAccelerometerData *accData, NSError *error) {
         }];
    }
}

- (void)stopAccelerator {
    [_motionManager stopAccelerometerUpdates];
}

- (void)startGyroscope {
    if ([_motionManager isAccelerometerAvailable]){
        NSLog(@"Accelerometer is available.");
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [_motionManager startGyroUpdatesToQueue:queue
                                    withHandler:
         ^(CMGyroData *gyroData, NSError *error) {
         }];
    }
}

- (void)stopGyroscope {
    [_motionManager stopGyroUpdates];
}

@end
