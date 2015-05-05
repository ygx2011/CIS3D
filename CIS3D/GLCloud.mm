//
//  GLCloud.m
//  CIS3D
//
//  Created by Neo on 15/5/5.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLCloud.h"

@interface GLCloud()

@end

@implementation GLCloud {
    GLuint _vbos[2];
}

@synthesize data = _data;

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        glGenBuffers(2, _vbos);
    }
    return self;
}

- (void)dealloc {
    glDeleteBuffers(2, _vbos);
}

#pragma mark - draw
- (void)draw {
    glBindBuffer(GL_ARRAY_BUFFER, _vbos[0]);
    glBufferData(GL_ARRAY_BUFFER, 3 * _data.count * sizeof(GLfloat), _data.coordinates, GL_STATIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbos[1]);
    glBufferData(GL_ARRAY_BUFFER, 4 * _data.count * sizeof(GLfloat), _data.colors, GL_STATIC_DRAW);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), 0);
    
    glDrawArrays(GL_POINTS, 0, _data.count);
    
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);}
@end
