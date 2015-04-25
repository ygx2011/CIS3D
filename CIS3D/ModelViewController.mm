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

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ModelViewController loaded");
    
    _shaderProgram  = [GLManager sharedInstance].shaderProgram;
    
    _glView = (GLKView *)self.view;
    _glView.context = [GLManager sharedInstance].glContext;
    _glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
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
