//
//  CISSensor.h
//  CIS3D
//
//  Created by Neo on 15/4/17.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CISSensor : NSObject

+ (CISSensor *)sharedInstance;
- (instancetype)init;

- (void)start;
- (void)stop;

- (void)startAccelerator;
- (void)stopAccelerator;

- (void)startGyroscope;
- (void)stopGyroscope;

@end
