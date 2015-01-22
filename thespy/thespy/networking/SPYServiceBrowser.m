//
//  SPYServiceBrowser.m
//  thespy
//
//  Created by zhaoquan on 15/1/22.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SPYServiceBrowser.h"

@implementation SPYServiceBrowser

- (id) init {
    self = [super init];
    if (self) {
        self.browser = [[NSNetServiceBrowser alloc] init];
        self.browser.delegate = self;
        [self.browser searchForServicesOfType:@"tcp" inDomain:@"thespy"];
        
    }
    return self;
}

- (void) dealloc{
    [self.browser setDelegate:nil];
    [self.browser stop];
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing{
//    [aNetService setDelegate:self];
    [aNetService resolveWithTimeout:5];
}

@end
