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
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    
//    [self set];
    
    return YES;
}

-(void)set{
    
    NSMutableArray *allWords = [[NSMutableArray alloc]initWithCapacity:100];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wordstxt" ofType:@"txt"];
    NSString *all = [NSString stringWithContentsOfFile:path usedEncoding:NULL error:nil];
    NSArray *arr = [all componentsSeparatedByString:@"\n"];
    if (arr) {
        for (int i=0; i<[arr count]; i++) {
            NSString *str = arr[i];
            NSArray *words = [str componentsSeparatedByString:@"——"];
            NSString *citizen = [(NSString*)words[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *spy = [(NSString*)words[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:citizen, @"citizen", spy, @"spy", [[NSNumber alloc]initWithInteger:0], @"times", [NSDate date], @"date", nil];
            [allWords addObject:dict];
        }
    }
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSMutableArray *al = [data objectForKey:@"words"];
    [al addObjectsFromArray:allWords];
    [data setObject:[[NSNumber alloc]initWithInteger:[al count]] forKey:@"words_count"];
    [data setObject:al forKey:@"words"];
    [data writeToFile:plistPath atomically:YES];
    
    [data writeToFile:@"/Users/zhaoquan/words.txt" atomically:YES];
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
