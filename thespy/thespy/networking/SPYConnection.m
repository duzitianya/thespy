//
//  SPYConnection.m
//  thespy
//
//  Created by zhaoquan on 15/1/23.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SPYConnection.h"

@implementation SPYConnection

- (id) initWithInput:(NSInputStream*)inputs output:(NSOutputStream*)outputs delegate:(id<NSStreamDelegate>)delegate{
    self = [super init];
    if (self) {
        self.input = inputs;
        self.input.delegate = delegate;
        [self.input scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.input open];
        
        self.output = outputs;
        self.output.delegate = delegate;
        [self.output scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.output open];
    }
    return self;
}

- (void) closeConnection{
    if (self.input) {
        [self.input removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.input = nil;
        self.input.delegate = nil;
        [self.input close];
    }
    if (self.output) {
        [self.output removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.output = nil;
        self.output.delegate = nil;
        [self.output close];
    }
}

- (void)cleanUpStream:(NSStream *)stream{
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream close];
    stream = nil;
}

- (void)dealloc{
    [self closeConnection];
}

@end
