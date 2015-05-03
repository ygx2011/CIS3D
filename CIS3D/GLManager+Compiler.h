//
//  GLManager+Compiler.h
//  CIS3D
//
//  Created by Neo on 15/5/3.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLManager.h"

static char vShaderStr[] =
"#version 300 es                          \n"
"layout(location = 0) in vec4 vPosition;  \n"
"void main()                              \n"
"{                                        \n"
"   gl_Position = vPosition;              \n"
"}                                        \n";

static char fShaderStr[] =
"#version 300 es                              \n"
"precision mediump float;                     \n"
"out vec4 fragColor;                          \n"
"void main()                                  \n"
"{                                            \n"
"   fragColor = vec4 ( 1.0, 0.0, 0.0, 1.0 );  \n"
"}                                            \n";

@interface GLManager (Compiler)

- (GLuint)initShaderWithSource:(const char *)source andType:(GLenum)type;
- (GLuint)initProgramWithvShader:(GLuint)vShader andfShader:(GLuint)fShader;

@end
