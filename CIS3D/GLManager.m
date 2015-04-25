//
//  GLManager.m
//  CIS3D
//
//  Created by Neo on 15/4/24.
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

@interface GLManager()

@end

@implementation GLManager

@synthesize shaderProgram = _shaderProgram;
@synthesize glContext     = _glContext;

+ (void)setup {
    [GLManager sharedInstance];
}

+ (GLManager *)sharedInstance {
    static GLManager *singletonGLManager;
    
    static dispatch_once_t singleton;
    dispatch_once(&singleton, ^{
        singletonGLManager = [[GLManager alloc] init];
    });
    
    return singletonGLManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        if (!_glContext) {
            NSLog(@"GLManager: Failed to init OpenGL");
        }
        
        [EAGLContext setCurrentContext:_glContext];
        if ((_shaderProgram = glCreateProgram()) == 0) {
            NSLog(@"Shader program create failed.");
            return 0;
        }
        
        GLuint vShader = [self loadShaderSource:vShaderStr withType:GL_VERTEX_SHADER];
        GLuint fShader = [self loadShaderSource:fShaderStr withType:GL_FRAGMENT_SHADER];
        glAttachShader(_shaderProgram, vShader);
        glAttachShader(_shaderProgram, fShader);
        glLinkProgram(_shaderProgram);
        
        GLint linkInfo;
        glGetProgramiv(_shaderProgram, GL_LINK_STATUS, &linkInfo);
        if (!linkInfo) {
            NSLog(@"Link failed");
            glDeleteProgram(_shaderProgram);
        }
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    }
    return self;
}

- (void)dealloc {
    glDeleteProgram(_shaderProgram);
}

#pragma mark - utility
- (GLuint)loadShaderSource:(const char *)source withType:(GLenum)type {
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

@end
