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

@synthesize glContext = _glContext;
@synthesize glView    = _glView;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"PointCloudViewController loaded");

    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_glContext) {
        NSLog(@"Failed to init OpenGL");
    }
    
    _glView = (GLKView *)self.view;
    _glView.context = _glContext;
    _glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
}

@end
