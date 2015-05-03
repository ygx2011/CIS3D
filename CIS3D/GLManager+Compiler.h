//
//  GLManager+Compiler.h
//  CIS3D
//
//  Created by Neo on 15/5/3.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLManager.h"

@interface GLManager (Compiler)

- (GLuint)initShaderWithSource:(const char *)source andType:(GLenum)type;
- (GLuint)initShaderWithName:(NSString *)path andType:(GLenum)type;

- (GLuint)initProgramWithvShader:(GLuint)vShader andfShader:(GLuint)fShader;

@end
