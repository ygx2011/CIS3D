//
//  GLShape.h
//  CIS3D
//
//  Created by Neo on 15/5/5.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

@protocol GLShape <NSObject>

- (instancetype)init;
- (void)draw;

@end
