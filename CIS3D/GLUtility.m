//
//  GLUtility.m
//  CIS3D
//
//  Created by Neo on 15/4/24.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLUtility.h"

@implementation GLUtility

+ (GLuint)loadShaderSource:(const char *)source withType:(GLenum)type {
    GLuint shader = glCreateShader(type);
    GLint  compileInfo;
    if (shader == 0) return 0;

    // 载入并编译shader代码
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileInfo);
    if (!compileInfo) {
        NSLog(@"GLUtility: Shader compile error!");
        glDeleteShader(shader);
    }
    return shader;
}

+ (GLuint)initShaderProgramWithVertexShader:(GLuint)vShader andFragmentShader:(GLuint)fShader {
    GLint linkInfo;
    GLuint shaderProgram = glCreateProgram();
    
    if (shaderProgram == 0) {
        NSLog(@"Shader program create failed.");
        return 0;
    }
    
    glAttachShader(shaderProgram, vShader);
    glAttachShader(shaderProgram, fShader);
    
    glLinkProgram(shaderProgram);
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &linkInfo);
    if (!linkInfo) {
        NSLog(@"Link failed");
        glDeleteProgram(shaderProgram);
    }
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    return shaderProgram;
}

@end
