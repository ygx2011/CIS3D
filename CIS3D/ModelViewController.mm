//
//  PointCloudViewController.m
//  CIS3D
//
//  Created by Neo on 15/4/9.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "ModelViewController.h"

@interface ModelViewController ()

@property (strong, nonatomic) EAGLContext *glContext;
@property (strong, nonatomic) GLKView     *glView;
@property (nonatomic)         GLuint       shaderProgram;

@end

@implementation ModelViewController

@synthesize glContext     = _glContext;
@synthesize glView        = _glView;
@synthesize shaderProgram = _shaderProgram;

#pragma mark - OpenGL setup and teardown
- (void)setupGL {
    [EAGLContext setCurrentContext:_glContext];
    // 编译加载渲染的核函数并链接生成GPU可执行程序
    GLuint vShader = [GLUtility loadShaderSource:vShaderStr
                                        withType:GL_VERTEX_SHADER];
    GLuint fShader = [GLUtility loadShaderSource:fShaderStr
                                        withType:GL_FRAGMENT_SHADER];
    _shaderProgram = [GLUtility initShaderProgramWithVertexShader:vShader
                                                andFragmentShader:fShader];
}

- (void)tearGL {
    [EAGLContext setCurrentContext:_glContext];
    glDeleteProgram(_shaderProgram);
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ModelViewController loaded");

    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_glContext) {
        NSLog(@"ModelViewController: Failed to init OpenGL");
    }
    
    _glView = (GLKView *)self.view;
    _glView.context = _glContext;
    _glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)dealloc {
    [self tearGL];
}

#pragma mark - update -> display -> cycle
// 更新点云、矩阵等等
- (void)update {
    
}

// 进行glUseProgram之类的绘制
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
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

@end
