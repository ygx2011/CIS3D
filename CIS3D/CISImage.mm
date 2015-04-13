//
//  CISImage.m
//  CIS3D
//
//  Created by Neo on 15/4/10.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISImage.h"

@interface CISImage()

@end

@implementation CISImage

@synthesize image         = _image;
@synthesize keyDescriptor = _keyDescriptor;
@synthesize keyPoints     = _keyPoints;

#pragma mark - life cycle
- (instancetype)initWithUIImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = [CISImage cvMatFromUIImage:image];
        
        cv::Ptr<cv::FeatureDetector>     detector  = cv::FeatureDetector::create("SIFT");
        cv::Ptr<cv::DescriptorExtractor> extractor = cv::DescriptorExtractor::create("SIFT");
            
        detector ->detect (*_image, *_keyPoints);
        extractor->compute(*_image, *_keyPoints, *_keyDescriptor);
            
        /* 完成特征提取以后，向SfM发布消息，将其添加至队列中 */
        NSDictionary *d = [NSDictionary dictionaryWithObject:self forKey:CISImageAdded];
        [[NSNotificationCenter defaultCenter] postNotificationName:CISImageAddedNotification
                                                            object:self
                                                            userInfo:d];
    }
    return self;
}

- (void)dealloc {
    delete _image;
    delete _keyDescriptor;
    delete _keyPoints;
}

#pragma mark - Utility convertions
+ (cv::Mat *)cvMatFromUIImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    // 8 bits per component, 4 channels (color channels + alpha)
    cv::Mat *cvMat = new cv::Mat(rows, cols, CV_8UC4);
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat->data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat->step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat &)cvMat {
    CGColorSpaceRef colorSpace;
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                              //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone |
                                        kCGBitmapByteOrderDefault,                  //bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault);                 //intent
    
    // Getting UIImage from CGImage
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

@end
