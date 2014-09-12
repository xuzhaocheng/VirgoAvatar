//
//  AppDelegate.m
//  VirgoAvatar
//
//  Created by xuzhaocheng on 14-8-25.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#define UICOLORFROMRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    [[UINavigationBar appearance] setBarTintColor:UICOLORFROMRGB(0xecf0f1)];
    
    MainViewController *vc = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
