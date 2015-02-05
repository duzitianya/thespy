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
- (NSData*)readGameDataWithInput:(NSInputStream*)input;
//发送数据
- (NSInteger) writeData:(NSData*)data;

- (void) closeConnection;
@end
