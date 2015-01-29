//
//  SPYConnection.h
//  thespy
//
//  Created by zhaoquan on 15/1/23.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPYConnection : NSObject<NSStreamDelegate>

@property (nonatomic, strong) NSInputStream *input;
@property (nonatomic, strong) NSOutputStream *output;

- (id) initWithInput:(NSInputStream*)inputs output:(NSOutputStream*)outputs;
//读数据
- (NSData*)readGameData;
//发送数据
- (NSInteger) writeData:(NSData*)data;
@end
