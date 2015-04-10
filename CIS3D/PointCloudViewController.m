//
//  PointCloudViewController.m
//  CIS3D
//
//  Created by Neo on 15/4/9.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "PointCloudViewController.h"

@interface PointCloudViewController()

@property(strong, nonatomic) EAGLContext *glContext;
@property(strong, nonatomic) GLKView     *glView;

@end

@implementation PointCloudViewController

@synthesize glContext = _glContext;
@synthesize glView    = _glView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_glContext) {
        NSLog(@"Failed to init OpenGL");
    }
    
    _glView = (GLKView *)self.view;
    _glView.context = _glContext;
    _glView.drawableColorFormat = GLKViewDrawableDepthFormat24;
    
}

@end