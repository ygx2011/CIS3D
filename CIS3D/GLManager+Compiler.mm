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
    if (shader == 0) {
        NSLog(@"%@: Shader init failed", self.class);
        return 0;
    }
    
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);
    
    GLint compileInfo;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileInfo);
    if (!compileInfo) {
        NSLog(@"%@: Shader compile error!", self.class);
        glDeleteShader(shader);
    }
    
    return shader;
}

- (GLuint)initShaderWithName:(NSString *)name andType:(GLenum)type {
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"glsl"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    if (!content) {
        NSLog(@"%@: Error loading shader: %@", self.class, error.localizedDescription);
    }

    return [self initShaderWithSource:[content UTF8String]
                              andType:type];
}

- (GLuint)initProgramWithvShader:(GLuint)vShader andfShader:(GLuint)fShader {
    GLuint shaderProgram = glCreateProgram();
    if (shaderProgram == 0) {
        NSLog(@"%@: Shader program create failed.", self.class);
        return 0;
    }
    
    glAttachShader(shaderProgram, vShader);
    glAttachShader(shaderProgram, fShader);
    glLinkProgram(shaderProgram);
    
    GLint linkInfo;
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &linkInfo);
    if (!linkInfo) {
        NSLog(@"%@: Link failed", self.class);
        glDeleteProgram(shaderProgram);
    }
    
    glDeleteShader(vShader);
    glDeleteShader(fShader);
    
    return shaderProgram;
}

@end
