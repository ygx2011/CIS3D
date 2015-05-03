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
@property (strong, nonatomic) GLManager   *glManager;

@end

@implementation ModelViewController

@synthesize glContext     = _glContext;
@synthesize glView        = _glView;
@synthesize glManager     = _glManager;

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ModelViewController loaded");

    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_glContext) {
        NSLog(@"GLManager: Failed to init OpenGL");
    }
    
    _glView = (GLKView *)self.view;
    _glView.context = _glContext;
    _glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:_glContext];
    _glManager = [[GLManager alloc] init];
}

#pragma mark - update -> display -> cycle
// 更新点云、矩阵等等
- (void)update {
    [_glManager update];
}

// 进行glUseProgram之类的绘制
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    _glManager.width  = (GLfloat)view.drawableWidth;
    _glManager.height = (GLfloat)view.drawableHeight;
    [_glManager draw];
}

@end
