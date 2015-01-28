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

- (id) init{
    self = [super init];
    if (self) {
//        self.clients = [[NSMutableArray alloc] initWithCapacity:5];
//        [self publishServer];
    }
    return self;
}

- (void) dealloc{
    [self.server setDelegate:nil];
    [self.server stop];
}

- (void) publishServer{
    NSString *deviceName = [UIDevice currentDevice].name;
    NSNetService *server = [[NSNetService alloc] initWithDomain:@"local." type:@"_thespy._tcp." name:[NSString stringWithFormat:@"%@-->创建的游戏",deviceName]];
    server.includesPeerToPeer = NO;
    [server setDelegate:self];
//    [server scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [server publishWithOptions:NSNetServiceListenForConnections];
    self.server = server;
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict{
    NSLog(@"-------------did not publish-----------");
    self.isServerOpen = NO;
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream{
    SPYConnection *connection = [[SPYConnection alloc] initWithInput:inputStream output:outputStream];
    NSData *himg = connection.readGameData;//first read HeadImg;
    NSData *nameAndId = connection.readGameData;//second read name,id
    
    NSString *str = [[NSString alloc] initWithData:nameAndId encoding:NSUTF8StringEncoding];
    NSString *nickname = [str componentsSeparatedByString:@","][0];
    NSString *devicename = [str componentsSeparatedByString:@","][1];
    
    PlayerBean *player = [PlayerBean initWithData:himg Name:nickname DeviceName:devicename];
    player.connection = connection;
//    [self.clients addObject:player];
    [self.delegate reloadClientListTable:player];
}

//服务发布成功后回调，打开输入输出流
- (void) netServiceDidPublish:(NSNetService *)sender{
    NSInputStream *inputstr = nil;
    NSOutputStream *outputstr = nil;
    [self.server getInputStream:&inputstr outputStream:&outputstr];
    
    self.connection = [[SPYConnection alloc] initWithInput:inputstr output:outputstr];
    
    NSLog(@"%@------%d", self.server.hostName, (int)self.server.port);
    
    self.isServerOpen = YES;
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{

    NSLog(@"event-->%ld", eventCode);
}

@end
