//
//  SPYConnection.m
//  thespy
//
//  Created by zhaoquan on 15/1/23.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SPYConnection.h"

@implementation SPYConnection

- (id) initWithInput:(NSInputStream*)inputs output:(NSOutputStream*)outputs {
    self = [super init];
    if (self) {
        self.input = inputs;
        self.output = outputs;
    }
    return self;
}

- (void) dealloc{
    if (self.input!=nil) {
        [self.input close];
        [self.input removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.input = nil;
    }
    if (self.output!=nil) {
        [self.output removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.output close];
        self.output = nil;
    }
}

//读数据
- (NSData*)readGameData{
    uint8_t buffer[1024];
    bzero(buffer, sizeof(buffer));
    NSInteger length;
    NSInteger len = [self.input read:buffer maxLength:sizeof(buffer)-1];
    if (len==length) {
        buffer[len] = '\0';
    }
    return [[NSData alloc] initWithBytes:buffer length:len];
}

//发送数据
- (NSInteger) writeData:(NSData*)data{
    //发送数据
//    NSData *data = [@"ready" dataUsingEncoding:NSUTF8StringEncoding];
//    [self.output write:[data bytes] maxLength:[data length]];
    
    NSInteger length = [data length];
    uint8_t *buffer;
    [data getBytes:buffer length:length];
    return [self.output write:buffer maxLength:length];
}

@end
