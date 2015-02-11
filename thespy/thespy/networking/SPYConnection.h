//
//  SPYConnection.h
//  thespy
//
//  Created by zhaoquan on 15/1/23.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NetWorkingDelegate.h"

@interface SPYConnection : NSObject

@property (nonatomic, strong) NSInputStream *input;
@property (nonatomic, strong) NSOutputStream *output;

@property (nonatomic, weak) id<NetWorkingDelegate> netDelegate;

- (id) initWithInput:(NSInputStream*)inputs output:(NSOutputStream*)outputs delegate:(id<NSStreamDelegate>)delegate;
- (void) closeConnection;
@end
