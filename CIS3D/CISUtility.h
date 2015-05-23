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

/* Conventions:
 * u_{i}, i \in {L, R} -> 2D coordinate in image plane
 * x_{i}, i \in {L, R} -> 2D homogeneous coordinate in world coordinates, (x_x, x_y, 1.0)
 * X -> 3D coordinate in world coordinates 
 */

#ifndef CIS3D_CISConsts_h
#define CIS3D_CISConsts_h

#define LOG

#define CISImageAdded                 @"CISImageAdded"
#define CISImageAddedNotification     @"CISImageAddedNotification"

#define CISImagePairAdded             @"CISImagePairAdded"
#define CISImagePairAddedNotification @"CISImagePairAdedNotifiation"

#define HEIGHT                        640.0
#define WIDTH                         480.0

#define IMG2WLD(y)                    (HEIGHT - y)

/* 特征匹配中使用 */
#define KNN_THRESHOLD                 0.6
#define MIN_2D_2D_MATCH_THRESHOLD     30
#define MIN_2D_3D_MATCH_THRESHOLD     20

/* 点云的最大数量 */
#define MAX_POINT_NUM                 100000

/* 测试摄像机[R | t]时随机检测点数目 */
#define RAND_CHECK_R_T_ITERATION      10
/* 摄像机距离的原点(Model)的半径 */
#define MIN_CAMERA_RADIUS             1
#define MAX_CAMERA_RADIUS             15

/* 图像队列中的搜索窗口 */
#define SEARCH_WINDOW                 5

#define FRONT_THRESHOLD_RATIO         0.65f

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

#endif
