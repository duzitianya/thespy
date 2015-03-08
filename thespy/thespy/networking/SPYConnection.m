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

- (void) dealloc{
    [self closeConnection];
//    NSLog(@"SPYConnection's dealloc has called....%@", [UIDevice currentDevice].name);
}

- (void) closeConnection{
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

- (void)cleanUpStream:(NSStream *)stream{
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream close];
    
    stream = nil;
}

@end
