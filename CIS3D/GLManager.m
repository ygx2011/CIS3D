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
    CC3GLMatrix *_projectMatrix;
    CC3GLMatrix *_modelViewMatrix;
    GLuint _projectUniform;
    GLuint _modelUniform;
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
        
        _projectUniform = glGetUniformLocation(_shaderProgram, "projectMatrix");
        _modelUniform   = glGetUniformLocation(_shaderProgram, "modelMatrix");

        _cube = [[GLCube alloc] init];
        _projectMatrix   = [CC3GLMatrix matrix];
        _modelViewMatrix = [CC3GLMatrix matrix];
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
    float h = 4.0f * _height / _width;
    [_projectMatrix populateFromFrustumLeft:-2   andRight:2
                                  andBottom:-h/2   andTop:h/2
                                    andNear:4      andFar:10];
    glUniformMatrix4fv(_projectUniform, 1, 0, _projectMatrix.glMatrix);
    
    [_modelViewMatrix populateFromTranslation:CC3VectorMake(0, 0, -7)];
    [_modelViewMatrix rotateBy:CC3VectorMake(CACurrentMediaTime() * 5, CACurrentMediaTime() * 5, 0)];
    glUniformMatrix4fv(_modelUniform, 1, 0, _modelViewMatrix.glMatrix);
}

@end
