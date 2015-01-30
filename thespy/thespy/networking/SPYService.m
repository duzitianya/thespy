//
//  SPYService.m
//  thespy
//
//  Created by zhaoquan on 15/1/22.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SPYService.h"

@implementation SPYService

+(SPYService *)shareInstance{
    static dispatch_once_t pred;
    static SPYService *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SPYService alloc] init];
    });
    return shared;
}

- (void) dealloc{
    [self closeService];
}

- (void) publishServer{
    NSString *deviceName = [UIDevice currentDevice].name;
    NSNetService *server = [[NSNetService alloc] initWithDomain:@"local." type:@"_thespy._tcp." name:[NSString stringWithFormat:@"%@-->创建的游戏",deviceName]];
    server.includesPeerToPeer = NO;
    [server setDelegate:self];
    [server scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [server publishWithOptions:NSNetServiceListenForConnections];
    self.server = server;
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict{
    self.isServerOpen = NO;
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream{
    SPYConnection *connection = [[SPYConnection alloc] initWithInput:inputStream output:outputStream];
    NSData *himg = [connection readGameData];//first read HeadImg;
    NSString *strs = @"abc,abc";
    NSData *name = [strs dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str = [[NSString alloc] initWithData:name encoding:NSUTF8StringEncoding];
    NSString *nickname = [str componentsSeparatedByString:@","][0];
    NSString *devicename = [str componentsSeparatedByString:@","][1];
    
    UIImage *img = [UIImage imageWithData:himg];
    PlayerBean *player = [PlayerBean initWithData:img Name:nickname DeviceName:devicename];
    player.connection = connection;
    [self.delegate reloadClientListTable:player];
    
    //获得客户端成功后，写会服务器端基础数据
    
}

//服务发布成功后回调
- (void) netServiceDidPublish:(NSNetService *)sender{
    self.isServerOpen = YES;
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"event-->%d", (int)eventCode);
}

- (void) closeService{
    [self.server removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.server setDelegate:nil];
    [self.server stop];
    NSLog(@"SPYService is stop...");
}

@end
