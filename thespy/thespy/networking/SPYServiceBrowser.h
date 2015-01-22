//
//  SPYServiceBrowser.h
//  thespy
//
//  Created by zhaoquan on 15/1/22.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPYServiceBrowser : NSObject<NSNetServiceBrowserDelegate>

@property (nonatomic, strong) NSNetServiceBrowser *browser;
@property (nonatomic, strong) NSInputStream *input;
@property (nonatomic, strong) NSOutputStream *output;

@end
