//
//  GLUtility.h
//  CIS3D
//
//  Created by Neo on 15/4/24.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

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

@interface GLUtility : NSObject

+ (GLuint)loadShaderSource:(const char *)source withType:(GLenum)type;
+ (GLuint)initShaderProgramWithVertexShader:(GLuint)vShader andFragmentShader:(GLuint)fShader;

@end
