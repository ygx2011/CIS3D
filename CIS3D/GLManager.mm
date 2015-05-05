//
//  GLManager.m
//  CIS3D
//
//  Created by Neo on 15/4/24.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>

#import "glm/gtc/matrix_transform.hpp"

#import "CISUtility.h"
#import "CISSfM.h"

#import "GLManager.h"
#import "GLManager+Compiler.h"

#import "GLCube.h"
#import "GLAxis.h"
#import "GLCloud.h"

@interface GLManager()

@property (nonatomic) GLuint shaderProgram;

@end

@implementation GLManager {
    GLCube *_cube;
    GLAxis *_axis;
    GLCloud *_cloud;
    
    GLuint _mvpUniform;
    GLuint _vbo[3];
    
    glm::mat4 _projection;
    glm::mat4 _model;
}

@synthesize shaderProgram = _shaderProgram;
@synthesize width = _width;
@synthesize height = _height;

@synthesize cameraRadius      = _radius;
@synthesize cameraAzimuth     = _azimuth;
@synthesize cameraElevation   = _elevation;
@synthesize inverseRotateSign = _sign;

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        GLuint _vShader = [self initShaderWithName:@"vShader" andType:GL_VERTEX_SHADER];
        GLuint _fShader = [self initShaderWithName:@"fShader" andType:GL_FRAGMENT_SHADER];
        _shaderProgram  = [self initProgramWithvShader:_vShader andfShader:_fShader];
        
        _mvpUniform = glGetUniformLocation(_shaderProgram, "mvpMatrix");

        _cube = [[GLCube alloc] init];
        _axis = [[GLAxis alloc] init];
        _cloud = [[GLCloud alloc] init];
        _cloud.data = [CISSfM sharedInstance].cloud;
        
        _radius    = 5.0f;
        _azimuth   = 0.0f;
        _elevation = 0.0f;
        _sign      = 1.0f;
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
    [_axis draw];
    [_cloud draw];
}

- (void)update {
    if (_height == 0) return;
    _radius = MAX(MIN(_radius, MAX_CAMERA_RADIUS), MIN_CAMERA_RADIUS);
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _projection = glm::perspective(45.0f, _width / _height, 0.1f, 100.0f);
        _model      = glm::mat4(1.0f);
    });

    glm::mat4 view = glm::lookAt(glm::vec3(_radius * cosf(_elevation) * sinf(_azimuth),
                                           _radius * sinf(_elevation),
                                           _radius * cosf(_elevation) * cosf(_azimuth)), // position
                                 glm::vec3(0, 0, 0),                                     // target
                                 glm::vec3(0, _sign, 0));                                // head
    
    glm::mat4 mvp = _projection * view * _model;
    glUniformMatrix4fv(_mvpUniform, 1, GL_FALSE, &mvp[0][0]);
}

@end
