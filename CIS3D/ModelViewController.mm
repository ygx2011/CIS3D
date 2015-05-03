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

@end

@implementation ModelViewController

@synthesize glContext     = _glContext;
@synthesize glView        = _glView;

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ModelViewController loaded");
    
    _glView = (GLKView *)self.view;
    _glView.context = [GLManager sharedInstance].glContext;
    _glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
}

#pragma mark - update -> display -> cycle
// 更新点云、矩阵等等
- (void)update {
    [[GLManager sharedInstance] update];
}

// 进行glUseProgram之类的绘制
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [[GLManager sharedInstance] draw];
}

@end
