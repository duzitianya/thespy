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
        self.input.delegate = self;
        [self.input scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.input open];
        
        self.output = outputs;
        self.output.delegate = self;
        [self.output scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.output open];
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

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@" >> NSStreamDelegate in Thread %@", [NSThread currentThread]);
    
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable: {
            uint8_t buf[1024];
            int numBytesRead = [(NSInputStream *)aStream read:buf maxLength:sizeof(buf)-1];
            if (numBytesRead > 0) {
                //读取数据
                [[NSData alloc] initWithBytes:buf length:numBytesRead];
            }
//            [self cleanUpStream:aStream];
            break;
        }
        case NSStreamEventErrorOccurred: {
            break;
        }
        case NSStreamEventEndEncountered: {
            break;
        }
        default:
            break;
    }
}

- (void)cleanUpStream:(NSStream *)stream{
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream close];
    
    stream = nil;
}

@end
