//
//  GLManager.m
//  CIS3D
//
//  Created by Neo on 15/4/24.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLManager.h"
#import "GLManager+Compiler.h"

@interface GLManager()

@end

@implementation GLManager {
    GLuint _vShader;
    GLuint _fShader;
}

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

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        if (!_glContext) {
            NSLog(@"GLManager: Failed to init OpenGL");
        }
        [EAGLContext setCurrentContext:_glContext];
        
        _vShader = [self initShaderWithSource:vShaderStr andType:GL_VERTEX_SHADER];
        _fShader = [self initShaderWithSource:fShaderStr andType:GL_FRAGMENT_SHADER];
        _shaderProgram = [self initProgramWithvShader:_vShader andfShader:_fShader];
        
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    }
    return self;
}

- (void)dealloc {
    glDeleteProgram(_shaderProgram);
}

#pragma mark - draw - update - loop
- (void)draw {
    GLfloat vVertices[] = { 0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f };
    
    // Clear the color buffer
    glClear ( GL_COLOR_BUFFER_BIT );
    
    // Use the program object
    glUseProgram(_shaderProgram);
    
    // Load the vertex data
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, vVertices);
    glEnableVertexAttribArray (0);
    
    glDrawArrays (GL_TRIANGLES, 0, 3);
}

- (void)update {
}

@end
