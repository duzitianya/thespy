//
//  AppDelegate.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayerInfoViewController.h"
#import "PlayerBean.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    PlayerBean *selfPlayer = [PlayerBean initWithData:@"img" Name:@"匿名" ID:@"0x20140620" Word:@""];
    
    PlayerInfoViewController *vc = [[PlayerInfoViewController alloc] init];
    vc.mainPlayer = selfPlayer;
    vc.title = @"游戏设置";
    
    self.navController = [[UINavigationController alloc] init];
    [self.navController pushViewController:vc animated:YES];
    [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end