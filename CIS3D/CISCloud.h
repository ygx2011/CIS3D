//
//  CISCloud.h
//  CIS3D
//
//  Created by Neo on 15/4/12.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

@interface CISCloud : NSObject

@property (nonatomic) GLfloat *coordinates;
@property (nonatomic) GLfloat *colors;
@property (nonatomic) int count;

- (instancetype)init;
- (void)addPointWithX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z
                 AndR:(GLfloat)r G:(GLfloat)g B:(GLfloat)b;
- (void)clear;

@end
