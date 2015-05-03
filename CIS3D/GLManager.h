//
//  GLManager.h
//  CIS3D
//
//  Created by Neo on 15/4/24.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/EAGL.h>

@interface GLManager : NSObject

@property (nonatomic) GLfloat width;
@property (nonatomic) GLfloat height;

- (instancetype)init;
- (void)draw;
- (void)update;

@end
