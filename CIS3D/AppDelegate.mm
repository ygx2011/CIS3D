//
//  AppDelegate.m
//  CIS3D
//
//  Created by Neo on 15/3/25.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIStoryboard *storyBoard = [[UIStoryboard alloc] init];
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CameraViewController *tab1 = [storyBoard instantiateViewControllerWithIdentifier:@"Camera"];
    ModelViewController  *tab2 = [storyBoard instantiateViewControllerWithIdentifier:@"Model"];
    PhotoViewController  *tab3 = [storyBoard instantiateViewControllerWithIdentifier:@"Photo"];
    
    [[NSNotificationCenter defaultCenter] addObserver:tab3
                                             selector:@selector(didReceiveImageAddedNotification:)
                                                 name:CISImageAddedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:tab3
                                             selector:@selector(didReceiveImagePairAddedNotification:)
                                                 name:CISImagePairAddedNotification
                                               object:nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[tab1, tab2, tab3];
    self.window.rootViewController = tabBarController;    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
