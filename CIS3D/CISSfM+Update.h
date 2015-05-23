//
//  CISSfM+Update.h
//  CIS3D
//
//  Created by Neo on 15/5/19.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "CISSfM.h"
#import "CISImagePair.h"

@interface CISSfM (Update)

- (BOOL)constructWithImagePair:(CISImagePair *)pair;
- (BOOL)updateWithImagePair:(CISImagePair *)pair;

@end
