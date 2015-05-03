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
#import "CC3GLMatrix.h"

@interface GLManager : NSObject

@property(nonatomic) GLuint shaderProgram;

- (instancetype)init;
- (void)drawInView:(GLKView *)view;
- (void)update;

@end
