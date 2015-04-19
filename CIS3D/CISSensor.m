//
//  CISSensor.m
//  CIS3D
//
//  Created by Neo on 15/4/17.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISSensor.h"

@implementation CISSensor

+ (CISSensor *)sharedInstance {
    static CISSensor *singletonSensor;
    
    static dispatch_once_t singleton;
    dispatch_once(&singleton, ^{
        singletonSensor = [[CISSensor alloc] init];
    });
    
    return singletonSensor;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
