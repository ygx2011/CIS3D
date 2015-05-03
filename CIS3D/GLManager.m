//
//  GLManager.m
//  CIS3D
//
//  Created by Neo on 15/4/24.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "GLManager.h"
#import "GLManager+Compiler.h"

GLfloat vVertices[] =
{
    1.0f,  -1.0f, 0.0f,        // v0
    1.0f,  1.0f,  0.0f,        // v1
    -1.0f,  1.0f, 0.0f,
    -1.0f, -1.0f, 0.0f,         // v2
    1.0f,  -1.0f, -1.0f,        // v0
    1.0f,  1.0f,  -1.0f,        // v1
    -1.0f,  1.0f, -1.0f,
    -1.0f, -1.0f, -1.0f,         // v2
};

GLfloat vColors[] =
{
    1.0f, 0.0f, 0.0f, 1.0f,   // c0
    0.0f, 1.0f, 0.0f, 1.0f,   // c1
    0.0f, 0.0f, 1.0f, 1.0f,    // c2
    0.2f, 0.4f, 0.0f, 1.0f
};

GLubyte vIndices[] = {
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

@interface GLManager()

@end

@implementation GLManager {
    GLuint _projectMatrix;
    GLuint _modelMatrix;
    GLuint _vbo[3];
}

@synthesize shaderProgram = _shaderProgram;

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        GLuint _vShader = [self initShaderWithSource:vShaderStr andType:GL_VERTEX_SHADER];
        GLuint _fShader = [self initShaderWithSource:fShaderStr andType:GL_FRAGMENT_SHADER];
        _shaderProgram = [self initProgramWithvShader:_vShader andfShader:_fShader];
        _projectMatrix = glGetUniformLocation(_shaderProgram, "projectMatrix");
        _modelMatrix   = glGetUniformLocation(_shaderProgram, "modelMatrix");
        
        memset(_vbo, 0, sizeof(_vbo));
    }
    return self;
}

- (void)dealloc {
    glDeleteProgram(_shaderProgram);
    glDeleteBuffers(3, _vbo);
}

#pragma mark - draw - update - loop
- (void)drawInView:(GLKView *)view {
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float h = 4.0f * (float)view.drawableHeight / (float)view.drawableWidth;
    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h / 2 andTop:h / 2 andNear:4 andFar:10];
    glUniformMatrix4fv(_projectMatrix, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *model = [CC3GLMatrix matrix];
    [model populateFromTranslation:CC3VectorMake(sin(CACurrentMediaTime()), 0, -7)];
    [model rotateBy:CC3VectorMake(CACurrentMediaTime() * 10, CACurrentMediaTime() * 10, 0)];
    glUniformMatrix4fv(_modelMatrix, 1, 0, model.glMatrix);
    
    glViewport(0, 0, (GLint)view.drawableWidth, (GLint)view.drawableHeight);

    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glUseProgram(_shaderProgram);
    
    if (_vbo[0] == 0 && _vbo[1] == 0 && _vbo[2] == 0) {
        glGenBuffers(3, _vbo);
        
        glBindBuffer(GL_ARRAY_BUFFER, _vbo[0]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vVertices), vVertices, GL_STATIC_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, _vbo[1]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vColors), vColors, GL_STATIC_DRAW);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _vbo[2]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vIndices), vIndices, GL_STATIC_DRAW);
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo[0]);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GL_FLOAT), 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo[1]);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(GL_FLOAT), 0);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _vbo[2]);
    glDrawElements(GL_TRIANGLES, sizeof(vIndices) / sizeof(vIndices[0]), GL_UNSIGNED_BYTE, 0);
    
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);

    glBindBuffer (GL_ARRAY_BUFFER, 0 );
    glBindBuffer (GL_ELEMENT_ARRAY_BUFFER, 0 );
}

- (void)update {
}

@end
