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
    [self.browser searchForServicesOfType:@"_spygame._tcp." inDomain:@"local"];
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
    NSNetService *server = [self.servers objectAtIndex:index];
    server.delegate = self;
    [server resolveWithTimeout:3];
}

//解析成功
- (void)netServiceDidResolveAddress:(NSNetService *)server{
    NSInputStream *inputs;
    NSOutputStream *outputs;
    if ([server getInputStream:&inputs outputStream:&outputs]) {
        
        SPYConnection *connection = [[SPYConnection alloc] initWithInput:inputs output:outputs];
        
//        [self.serversConnections addObject:connection];

    }
}


@end
