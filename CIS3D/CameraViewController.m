//
//  CameraViewController.m
//  CIS3D
//
//  Created by Neo on 15/4/4.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController() 

@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureDeviceInput       *videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput  *stillImageOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureDevice            *rearCamera;

@end

@implementation CameraViewController

@synthesize session           = _session;
@synthesize videoInput        = _videoInput;
@synthesize stillImageOutput  = _stillImageOutput;
@synthesize previewLayer      = _previewLayer;
@synthesize rearCamera        = _rearCamera;

#pragma mark - Device selecting
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _session = [[AVCaptureSession alloc] init];
    if ([_session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        _session.sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    if ([_session canAddInput:_videoInput]) {
        [_session addInput:_videoInput];
    }
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([_session canAddOutput:_stillImageOutput]) {
        [_stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
        [_session addOutput:_stillImageOutput];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];

        CALayer *layer = [self.view layer];
        [layer setMasksToBounds:YES];
        
        [_previewLayer setFrame:[self.view bounds]];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        
        [layer insertSublayer:_previewLayer below:[[layer sublayers] objectAtIndex:0]];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_session) {
        [_session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_session) {
        [_session stopRunning];
    }
}

@end
