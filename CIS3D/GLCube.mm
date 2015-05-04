//
//  GLCube.m
//  CIS3D
//
//  Created by Neo on 15/5/3.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLCube.h"

/* 一个Cube必有的数组 */
static GLfloat vCoordinates[] = {
    1.0f,  -1.0f, 0.5f,
    1.0f,  1.0f,  0.5f,
    -1.0f,  1.0f, 0.5f,
    -1.0f, -1.0f, 0.5f,
    1.0f,  -1.0f, -0.5f,
    1.0f,  1.0f,  -0.5f,
    -1.0f,  1.0f, -0.5f,
    -1.0f, -1.0f, -0.5f
};

static GLfloat vColors[] = {
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    0.0f, 1.0f, 0.0f, 1.0f,
    0.0f, 1.0f, 0.0f, 1.0f,
    0.0f, 0.0f, 1.0f, 1.0f,
    0.0f, 0.0f, 1.0f, 1.0f,
    0.0f, 0.0f, 0.0f, 1.0f,
    0.0f, 0.0f, 0.0f, 1.0f
};

static GLubyte vIndices[] = {
    0, 1, 2,
    2, 3, 0,
    4, 6, 5,
    4, 7, 6,
    2, 7, 3,
    7, 6, 2,
    0, 4, 1,
    4, 1, 5,
    6, 2, 1,
    1, 6, 5,
    0, 3, 7,
    0, 7, 4
};

@interface GLCube()

@end

@implementation GLCube {
    GLuint _vbos[3];
}

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        glGenBuffers(3, _vbos);
        glBindBuffer(GL_ARRAY_BUFFER, _vbos[0]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vCoordinates), vCoordinates, GL_STATIC_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, _vbos[1]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vColors), vColors, GL_STATIC_DRAW);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _vbos[2]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vIndices), vIndices, GL_STATIC_DRAW);
    }
    return self;
}

- (void)dealloc {
    glDeleteBuffers(3, _vbos);
}

#pragma mark - draw
- (void)draw {
    glBindBuffer(GL_ARRAY_BUFFER, _vbos[0]);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GL_FLOAT), 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbos[1]);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(GL_FLOAT), 0);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _vbos[2]);
    glDrawElements(GL_TRIANGLES, sizeof(vIndices) / sizeof(vIndices[0]), GL_UNSIGNED_BYTE, 0);
    
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
    
    glBindBuffer (GL_ARRAY_BUFFER, 0);
    glBindBuffer (GL_ELEMENT_ARRAY_BUFFER, 0);
}

@end
