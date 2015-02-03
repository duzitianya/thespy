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
    NSInteger port = [sender port];
    NSString *hostname = [sender hostName];
    NSString *type = [sender type];
    NSLog(@"from SPYService-->hostname:%@,  port:%d,  type:%@", hostname, (int)port, type);
    
    SPYConnection *connection = [[SPYConnection alloc] initWithInput:inputStream output:outputStream];
    NSData *data = [connection readGameDataWithInput:nil];
    NSArray *arrs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([arrs count]==3) {
        NSData *imgData = arrs[0];
        NSString *name = arrs[1];
        NSString *deviceName = arrs[2];
        
        UIImage *img = [UIImage imageWithData:imgData];
        PlayerBean *player = [PlayerBean initWithData:img Name:name DeviceName:deviceName];
        player.connection = connection;
        [self.delegate reloadClientListTable:player];
        
        //获得客户端成功后，向所有已连接客户端写回服务器端基础数据
        NSArray *gamedata =[[NSArray alloc]initWithObjects:@"15", @"10", @"3", @"2", nil];
        NSData *repeatData = [NSKeyedArchiver archivedDataWithRootObject:gamedata];
        NSInteger dataLength = [connection writeData:repeatData];
        NSLog(@"repeat length ... %d", (int)dataLength);
        [connection closeConnection];
    }
}

//服务发布成功后回调
- (void) netServiceDidPublish:(NSNetService *)sender{
    self.isServerOpen = YES;
}

- (void) closeService{
    [self.server removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.server setDelegate:nil];
    [self.server stop];
    self.isServerOpen = NO;
    NSLog(@"SPYService is stop...");
}

@end
