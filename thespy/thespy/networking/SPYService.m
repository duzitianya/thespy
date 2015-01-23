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
        
        NSString *deviceName = [UIDevice currentDevice].name;
        NSNetService *server = [[NSNetService alloc] initWithDomain:@"local." type:@"_spygame._tcp." name:deviceName];
        server.includesPeerToPeer = YES;
        [server setDelegate:self];
        [server scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [server publishWithOptions:NSNetServiceListenForConnections];
        self.server = server;
        
    }
    return self;
}

- (void) dealloc{
    [self.server setDelegate:nil];
    [self.server stop];
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict{
    NSLog(@"-------------not-----------");
    self.isServerOpen = NO;
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream{
    
    self.connection = [[SPYConnection alloc] initWithInput:inputStream output:outputStream];
    
    
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


@end
