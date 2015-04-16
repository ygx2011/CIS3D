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

@property (strong, nonatomic) IBOutlet UIView            *previewView;
@property (strong, nonatomic) IBOutlet UIImageView       *imageView;

- (IBAction)didCaputre:(UIButton *)sender;

@end

@implementation CameraViewController

@synthesize session           = _session;
@synthesize videoInput        = _videoInput;
@synthesize stillImageOutput  = _stillImageOutput;
@synthesize previewLayer      = _previewLayer;
@synthesize previewView       = _previewView;
@synthesize imageView         = _imageView;

#pragma mark - device selecting
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

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CameraViewController loaded");
    
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
        
        CALayer *layer = [_previewView layer];
        [layer setMasksToBounds:YES];
        
        [_previewLayer setFrame:[_previewView bounds]];
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

#pragma mark - !!! IMPORTANT MODUAL -- Event-driven loop is evoked here !!!
- (IBAction)didCaputre:(UIButton *)sender {
    AVCaptureConnection * videoConnection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (!videoConnection) {
        NSLog(@"Error taking pictures.");
        return;
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                   completionHandler:
     ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         /* 异步获取图片 */
         if (imageDataSampleBuffer == NULL) {
             return;
         }
         
         UIImage *image = [UIImage imageWithData:[AVCaptureStillImageOutput
                                                  jpegStillImageNSDataRepresentation:imageDataSampleBuffer]];
         
         /* 获取图片后，在CISImage初始化中进行一系列特征提取运算 */
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             CISImage *capturedImage = [[CISImage alloc] initWithUIImage:image];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 /* 更新UI */
                 _imageView.image = [CISImage UIImageFromCVMat:capturedImage.drawImage];
                 
                 /* 将图像添加至SfM维护的队列中 */
                 [[CISSfM sharedInstance] addImage:capturedImage];
             });
         });
     }];
}

@end
