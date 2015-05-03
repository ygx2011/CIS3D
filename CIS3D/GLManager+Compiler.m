//
//  GLManager+Compiler.m
//  CIS3D
//
//  Created by Neo on 15/5/3.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLManager+Compiler.h"

@implementation GLManager (Compiler)

- (GLuint)initShaderWithSource:(const char *)source andType:(GLenum)type {
    GLuint shader = glCreateShader(type);
    GLint  compileInfo;
    if (shader == 0) return 0;
    
    // 载入并编译shader代码
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileInfo);
    if (!compileInfo) {
        NSLog(@"GLManager: Shader compile error!");
        glDeleteShader(shader);
    }
    return shader;
}

- (GLuint)initProgramWithvShader:(GLuint)vShader andfShader:(GLuint)fShader {
    GLuint shaderProgram = glCreateProgram();
    if (shaderProgram == 0) {
        NSLog(@"Shader program create failed.");
        return 0;
    }
    
    glAttachShader(shaderProgram, vShader);
    glAttachShader(shaderProgram, fShader);
    glLinkProgram(shaderProgram);
    
    GLint linkInfo;
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &linkInfo);
    if (!linkInfo) {
        NSLog(@"Link failed");
        glDeleteProgram(shaderProgram);
    }
    
    glDeleteShader(vShader);
    glDeleteShader(fShader);
    
    return shaderProgram;
}

@end
