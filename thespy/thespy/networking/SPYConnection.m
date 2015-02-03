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
    [self closeConnection];
    NSLog(@"SPYConnection's dealloc has called....%@", [UIDevice currentDevice].name);
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

- (NSData*)readGameDataWithInput:(NSInputStream*)input{
    if (input==nil) {
        input = self.input;
    }
    NSMutableData *mdata = [[NSMutableData alloc] initWithCapacity:1024];
    uint8_t buf[1024];
    BOOL shouldBreak = NO;
    while (!shouldBreak) {
        long numBytesRead = [input read:buf maxLength:sizeof(buf)-1];
        if (numBytesRead > 0) {
            //读取数据
            [mdata appendData:[[NSData alloc] initWithBytes:buf length:numBytesRead]];
        }else{
            shouldBreak = YES;
        }
    }
    return [mdata subdataWithRange:NSMakeRange(0, [mdata length])];
}

//发送数据
- (NSInteger) writeData:(NSData*)data{
    //发送数据
    NSInteger length = [data length];
    uint8_t buffer[length];
    [data getBytes:buffer length:length];
    [self.output open];
    NSLog(@"writeData length---->%d, %d", (int)[data length], [self.output hasSpaceAvailable]);
    return [self.output write:buffer maxLength:length];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"NSStreamDelegate--->stream status : %d", (int)[aStream streamStatus]);
    switch (eventCode) {
        case NSStreamEventNone:
            NSLog(@"SPYConnection-->NSStreamEventNone");
            break;
        case NSStreamEventOpenCompleted:
            NSLog(@"SPYConnection-->NSStreamEventOpenCompleted");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"SPYConnection-->NSStreamEventHasBytesAvailable");
            NSLog(@"%@", [aStream description]);
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"SPYConnection-->NSStreamEventHasSpaceAvailable");
            NSLog(@"%@", [aStream description]);
            break;
        case NSStreamEventErrorOccurred:{
            NSLog(@"SPYConnection-->NSStreamEventErrorOccurred");
            //出错的时候
            NSError *error = [aStream streamError];
            if (error != NULL){
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle: [error localizedDescription]
                                           message: [error localizedFailureReason]
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                [errorAlert show];
            }
            break;
        }
        case NSStreamEventEndEncountered:
            NSLog(@"SPYConnection-->NSStreamEventEndEncountered");
            break;
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
