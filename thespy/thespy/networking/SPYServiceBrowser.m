//
//  SPYServiceBrowser.m
//  thespy
//
//  Created by zhaoquan on 15/1/22.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SPYServiceBrowser.h"

@implementation SPYServiceBrowser

+(SPYServiceBrowser *)shareInstance{
    static dispatch_once_t pred;
    static SPYServiceBrowser *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SPYServiceBrowser alloc] init];
    });
    return shared;
}

- (instancetype) init{
    self = [super init];
    if (self) {
        self.servers = [[NSMutableArray alloc] initWithCapacity:5];
//        self.serversConnections = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void) stop {
    if ( self.browser == nil ) {
        return;
    }
    
    [self.browser setDelegate:nil];
    [self.browser stop];
    [self.servers removeAllObjects];
    self.browser = nil;
}

- (void) dealloc{
    if (self.browser!=nil) {
        [self stop];
    }
}

- (void) browseService{
    [self.browser stop];
    self.browser.delegate = nil;
    self.browser = nil;
    
    self.browser = [[NSNetServiceBrowser alloc] init];
    self.browser.includesPeerToPeer = YES;
    self.browser.delegate = self;
    [self.browser searchForServicesOfType:@"_thespy._tcp." inDomain:@"local"];
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser
            didFindService:(NSNetService *)netService
                moreComing:(BOOL)moreServicesComing{
    if ( ! [self.servers containsObject:netService] ) {
        [self.servers addObject:netService];
    }
    
    if ( moreServicesComing ) {
        return;
    }
    
    [self.delegate reloadServerListTable];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser
         didRemoveService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing{
    [self.servers removeObject:netService];
    
    if ( moreServicesComing ) {
        return;
    }
    
    [self.delegate reloadServerListTable];
}

//连接到选定的服务器
- (void) connectNSServer:(NSInteger)index{
    self.service = [self.servers objectAtIndex:index];
    self.service.delegate = self;
    [self.service resolveWithTimeout:30];
}

//解析成功
- (void)netServiceDidResolveAddress:(NSNetService *)server{
    self.service = server;
    
    NSInteger port = [server port];
    NSString *hostname = [server hostName];
    NSString *type = [server type];
    NSLog(@"host:%@,  port:%d,  type:%@", hostname, (int)port, type);
    
    //解析成功后连接服务器
    NSInputStream *inputs;
    NSOutputStream *outputs;

    [NSStream getStreamsToHostNamed:hostname port:port inputStream:&inputs outputStream:&outputs];
    if (inputs!=nil&&outputs!=nil) {
        SPYConnection *connection = [[SPYConnection alloc] initWithInput:inputs output:outputs];
        //向服务器发送客户端数据
        UIImage *img = [[SPYFileUtil shareInstance]getUserHeader];
        NSString *name = [[SPYFileUtil shareInstance]getUserName];
        [connection writeData:UIImagePNGRepresentation(img)];//写入头像数据
        [connection writeData:[type dataUsingEncoding:NSUTF8StringEncoding]];//写入用户名
    }
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream{
    SPYConnection *connection = [[SPYConnection alloc] initWithInput:inputStream output:outputStream];
    NSLog(@"client didAcceptConnection");
}

@end
