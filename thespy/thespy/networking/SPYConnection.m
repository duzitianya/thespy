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

+ (int)readOperationType:(NSInputStream*)input{
    int oper = -1;
    uint8_t buf[1];
    long size = [input read:buf maxLength:sizeof(buf)];
    if (size==1) {
        oper = buf[0];
    }
    return oper;
}

+ (void)writeOperationType:(NSOutputStream*)out OperType:(int)oper{
    uint8_t size[1];
    size[0] = oper;
    [out write:size maxLength:sizeof(size)];
}

+ (int)readGameDataDirectWithInput:(NSInputStream*)input{
    uint8_t streamSize[4];
    long size = [input read:streamSize maxLength:sizeof(streamSize)];
    int remainingToRead = -1;
    if (size==4) {
        remainingToRead = ((streamSize[0]<<24)&0xff000000)+((streamSize[1]<<16)&0xff0000)+((streamSize[2]<<8)&0xff00)+(streamSize[3] & 0xff);
        NSLog(@"===========remaining to read size is : %d============", remainingToRead);
    }
    return remainingToRead;
}

+ (NSData*)readGameDataWithInput:(NSInputStream*)input size:(int)size{
    uint8_t buf[size];
    long numBytesRead = [input read:buf maxLength:sizeof(buf)];
    if (numBytesRead>0&&numBytesRead==size) {
        return [NSData dataWithBytes:buf length:numBytesRead];
    }
    return NULL;
}

//发送数据
+ (NSInteger) writeData:(NSData*)data withStream:(NSOutputStream*)aStream{
    if ([aStream hasSpaceAvailable]) {
        NSInteger length = [data length];
        //先行发送流长度标记
        uint8_t size[4];
        for(int i = 0;i<4;i++){
            size[i] = (Byte)(length>>8*(3-i)&0xff);
        }
        [aStream write:size maxLength:4];
        
        //发送真实数据
        uint8_t buffer[length];
        [data getBytes:buffer length:length];
        return [aStream write:buffer maxLength:sizeof(buffer)];
    }
    return -1;
}

- (void)cleanUpStream:(NSStream *)stream{
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream close];
    
    stream = nil;
}

@end
