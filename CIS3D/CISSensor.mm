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

@end
