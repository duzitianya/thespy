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
    
    PlayerInfoViewController *vc = [[PlayerInfoViewController alloc] init];
    vc.title = @"我的游戏";
    
    self.navController = [[UINavigationController alloc] init];
    [self.navController pushViewController:vc animated:YES];
    [self.window addSubview:self.navController.view];
//    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
    
    //初始化数据库，如果已经初始化过，不再继续
//    GameResult *result = [[GameResult alloc] initWithName:@"小红帽" Role:@"卧底" Victory:@"胜利"];
//    [[GameDB shareInstance] addGameResult:result];
    
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
