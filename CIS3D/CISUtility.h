//
//  CISUtility.h
//  CIS3D
//
//  Created by Neo on 15/4/11.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

/* Logically, the most important code snippets includes:
 * 1. ModelViewController - the event-driven loop
 * 2. CISSfM - manages the queues
 * 3. CISImagePair - match 2 images and 2d -> 3d
 */
#ifndef CIS3D_CISConsts_h
#define CIS3D_CISConsts_h

#define LOG

#define CISImageAdded                 @"CISImageAdded"
#define CISImageAddedNotification     @"CISImageAddedNotification"

#define CISImagePairAdded             @"CISImagePairAdded"
#define CISImagePairAddedNotification @"CISImagePairAdedNotifiation"

/* 特征匹配中使用 */
#define KNN_THRESHOLD                 0.6
#define MIN_MATCH_THRESHOLD           100

/* 点云的最大数量 */
#define MAX_POINT_NUM                 100000

/* 摄像机距离的原点(Model)的半径 */
#define MIN_CAMERA_RADIUS             1
#define MAX_CAMERA_RADIUS             15

#define SEARCH_WINDOW                 5

#endif
