//
//  SPYConnection.h
//  thespy
//
//  Created by zhaoquan on 15/1/23.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SPYConnection : NSObject

@property (nonatomic, strong) NSInputStream *input;
@property (nonatomic, strong) NSOutputStream *output;

- (id) initWithInput:(NSInputStream*)inputs output:(NSOutputStream*)outputs delegate:(id<NSStreamDelegate>)delegate;
//读数据
+ (NSData*)readGameDataWithInput:(NSInputStream*)input size:(int)size;
+ (int)readGameDataDirectWithInput:(NSInputStream*)input;
//读操作类型数据
+ (int)readOperationType:(NSInputStream*)input;

//发送数据
+ (NSInteger) writeData:(NSData*)data withStream:(NSOutputStream*)aStream;
//写操作类型数据
+ (void)writeOperationType:(NSOutputStream*)out OperType:(int)oper;

- (void) closeConnection;
@end
