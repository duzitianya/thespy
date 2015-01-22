//
//  SPYService.h
//  thespy
//
//  Created by zhaoquan on 15/1/22.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SPYService : NSObject<NSNetServiceDelegate>

@property (nonatomic, strong) NSNetService *server;
@property (nonatomic, strong) NSInputStream *input;
@property (nonatomic, strong) NSOutputStream *output;

@end
