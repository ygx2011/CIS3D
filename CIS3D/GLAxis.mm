//
//  GLAxis.m
//  CIS3D
//
//  Created by Neo on 15/5/5.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLAxis.h"

/* 三个坐标轴必有的数组 */
static GLfloat axisCoordinates[] = {
    0.0f, 0.0f, 0.0f,
    0.0f, 1.0f, 0.0f
};

static GLfloat axisColors[] = {
    1.0f, 0.0f, 0.0f, 0.0f
};

@interface GLAxis ()

@end

@implementation GLAxis {
    GLuint _vbos[2];
}

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
    setCoordinates(2.0f, 0.0f, 0.0f);
    setColors(1.0f, 0.0f, 0.0f, 1.0f);
    [self drawLine];
    
    setCoordinates(0.0f, 2.0f, 0.0f);
    setColors(0.0f, 1.0f, 0.0f, 1.0f);
    [self drawLine];
    
    setCoordinates(0.0f, 0.0f, 2.0f);
    setColors(0.0f, 0.0f, 1.0f, 1.0f);
    [self drawLine];
}

#pragma mark - utilities
- (void)drawLine {
    glBindBuffer(GL_ARRAY_BUFFER, _vbos[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(axisCoordinates), axisCoordinates, GL_STATIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbos[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(axisColors), axisColors, GL_STATIC_DRAW);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), 0);
    
    glLineWidth(5.0f);
    glDrawArrays(GL_LINES, 0, 3);
    
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

void setCoordinates(GLfloat x, GLfloat y, GLfloat z) {
    axisCoordinates[3] = x;
    axisCoordinates[4] = y;
    axisCoordinates[5] = z;
}

void setColors(GLfloat r, GLfloat g, GLfloat b, GLfloat a) {
    axisColors[0] = r;
    axisColors[1] = g;
    axisColors[2] = b;
    axisColors[3] = a;
}

@end
