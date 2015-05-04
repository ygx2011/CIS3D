//
//  GLManager.m
//  CIS3D
//
//  Created by Neo on 15/4/24.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLManager.h"
#import "GLManager+Compiler.h"
#import "GLCube.h"
#import "glm/gtc/matrix_transform.hpp"

@interface GLManager()

@property (nonatomic) GLuint shaderProgram;

@end

@implementation GLManager {
    GLCube *_cube;
    GLuint _mvpUniform;
    GLuint _vbo[3];
}

@synthesize shaderProgram = _shaderProgram;
@synthesize width = _width;
@synthesize height = _height;

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        GLuint _vShader = [self initShaderWithName:@"vShader" andType:GL_VERTEX_SHADER];
        GLuint _fShader = [self initShaderWithName:@"fShader" andType:GL_FRAGMENT_SHADER];
        _shaderProgram = [self initProgramWithvShader:_vShader andfShader:_fShader];
        
        _mvpUniform = glGetUniformLocation(_shaderProgram, "mvpMatrix");

        _cube = [[GLCube alloc] init];
    }
    return self;
}

- (void)dealloc {
    glDeleteProgram(_shaderProgram);
}

#pragma mark - draw - update - loop
- (void)draw {
    glViewport(0, 0, _width, _height);

    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glUseProgram(_shaderProgram);
    
    [_cube draw];
}

- (void)update {
    glm::mat4 Projection = glm::perspective(45.0f, 4.0f / 3.0f, 0.1f, 100.0f);
    glm::mat4 View = glm::lookAt(glm::vec3(4, 3, 3), glm::vec3(0, 1, 0), glm::vec3(0, 1, 0));
    glm::mat4 Model = glm::mat4(1.0f);
    glm::mat4 mvp = Projection * View * Model;
    glUniformMatrix4fv(_mvpUniform, 1, GL_FALSE, &mvp[0][0]);
    
//    glUniformMatrix4fv(_modelUniform, 1, 0, _modelViewMatrix.glMatrix);
}

@end
