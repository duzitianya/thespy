//
//  SPYService.m
//  thespy
//
//  Created by zhaoquan on 15/1/22.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SPYService.h"

@implementation SPYService

- (id) init{
    self = [super init];
    if (self) {
        
        NSString *deviceName = [UIDevice currentDevice].name;
        self.server = [[NSNetService alloc] initWithDomain:@"thespy." type:@"_witap2._tcp." name:deviceName port:0];
        self.server.includesPeerToPeer = YES;
        [self.server setDelegate:self];
        [self.server publishWithOptions:NSNetServiceListenForConnections];
    }
    return self;
}

- (void) dealloc{
    [self.server setDelegate:nil];
    [self.server stop];
}

- (void) netServiceDidPublish:(NSNetService *)sender{
    NSInputStream *inputstr = self.input;
    NSOutputStream *outputstr = self.output;
    [self.server getInputStream:&inputstr outputStream:&outputstr];
//    self.input = inputstr;
//    self.output = outputstr;
}

- (void) netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict{
    NSLog(@"");
}


@end
