//
//  NSStream+StreamsToHost.h
//  thespy
//
//  Created by 独自天涯 on 15/1/29.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStream (StreamsToHost)

+ (void)getStreamsToHostNamed:(NSString *)hostName
                         port:(NSInteger)port
                  inputStream:(out NSInputStream **)inputStreamPtr
                 outputStream:(out NSOutputStream **)outputStreamPtr;

@end
