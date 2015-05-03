//
//  GLManager+Compiler.h
//  CIS3D
//
//  Created by Neo on 15/5/3.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLManager.h"

static char vShaderStr[] =
"#version 300 es                            \n"
"uniform mat4 projectMatrix;                \n"
"uniform mat4 modelMatrix;                  \n"
"layout(location = 0) in vec4 a_position;   \n"
"layout(location = 1) in vec4 a_color;      \n"
"out vec4 v_color;                          \n"
"void main()                                \n"
"{                                          \n"
"    v_color = a_color;                     \n"
"    gl_Position = projectMatrix * modelMatrix * a_position;\n"
"}";

static char fShaderStr[] =
"#version 300 es            \n"
"precision mediump float;   \n"
"in vec4 v_color;           \n"
"out vec4 o_fragColor;      \n"
"void main()                \n"
"{                          \n"
"    o_fragColor = v_color; \n"
"}" ;

@interface GLManager (Compiler)

- (GLuint)initShaderWithSource:(const char *)source andType:(GLenum)type;
- (GLuint)initProgramWithvShader:(GLuint)vShader andfShader:(GLuint)fShader;

@end
