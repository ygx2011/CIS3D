//
//  CISCloud.m
//  CIS3D
//
//  Created by Neo on 15/4/12.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISUtility.h"
#import "CISCloud.h"

@interface CISCloud ()

@end

@implementation CISCloud

@synthesize coordinates = _coordinates;
@synthesize colors      = _colors;
@synthesize count       = _count;

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _coordinates = (GLfloat *)malloc(3 * MAX_POINT_NUM * sizeof(GLfloat));
        _colors      = (GLfloat *)malloc(4 * MAX_POINT_NUM * sizeof(GLfloat));
        _count = 0;
    }
    return self;
}

- (void)dealloc {
    free(_coordinates);
    free(_colors);
}

#pragma mark - array access
- (cv::Point3f)pointAtIndex:(int)index {
    cv::Point3f pt;
    int baseIndex = _count * 3;
    pt.x = _coordinates[baseIndex    ];
    pt.y = _coordinates[baseIndex + 1];
    pt.z = _coordinates[baseIndex + 2];
    return pt;
}

- (void)addPointWithX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z
                 AndR:(GLfloat)r G:(GLfloat)g B:(GLfloat)b {
    int baseIndex = _count * 3, colorIndex = _count * 4;
    _coordinates[baseIndex    ] = x;
    _coordinates[baseIndex + 1] = y;
    _coordinates[baseIndex + 2] = z;
    _colors[colorIndex    ] = r;
    _colors[colorIndex + 1] = g;
    _colors[colorIndex + 2] = b;
    _colors[colorIndex + 3] = 1.0f;
    _count ++;
    NSLog(@"%d", _count);
}

- (void)clear {
    _count = 0;
}

@end
