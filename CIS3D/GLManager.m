//
//  GLManager.m
//  CIS3D
//
//  Created by Neo on 15/4/24.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLManager.h"
#import "GLManager+Compiler.h"
#import "CC3GLMatrix.h"
#import "GLCube.h"

@interface GLManager()

@property (nonatomic) GLuint shaderProgram;

@end

@implementation GLManager {
    GLCube *_cube;
    GLuint _projectMatrix;
    GLuint _modelMatrix;
    GLuint _vbo[3];
}

@synthesize shaderProgram = _shaderProgram;
@synthesize width = _width;
@synthesize height = _height;

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        GLuint _vShader = [self initShaderWithSource:vShaderStr andType:GL_VERTEX_SHADER];
        GLuint _fShader = [self initShaderWithSource:fShaderStr andType:GL_FRAGMENT_SHADER];
        _shaderProgram = [self initProgramWithvShader:_vShader andfShader:_fShader];
        
        _projectMatrix = glGetUniformLocation(_shaderProgram, "projectMatrix");
        _modelMatrix   = glGetUniformLocation(_shaderProgram, "modelMatrix");

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
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float h = 4.0f * _width / _height;
    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h / 2 andTop:h / 2 andNear:4 andFar:10];
    glUniformMatrix4fv(_projectMatrix, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *model = [CC3GLMatrix matrix];
    [model populateFromTranslation:CC3VectorMake(sin(CACurrentMediaTime()), 0, -7)];
    [model rotateBy:CC3VectorMake(CACurrentMediaTime() * 10, CACurrentMediaTime() * 10, 0)];
    glUniformMatrix4fv(_modelMatrix, 1, 0, model.glMatrix);
}

@end
