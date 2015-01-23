//
//  SPYServiceBrowser.h
//  thespy
//
//  Created by zhaoquan on 15/1/22.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPYConnection.h"
#import "SPYServiceBrowser.h"

@protocol SPYServiceBrowserDelegate <NSObject>

@optional
- (void) reloadServerListTable;

@end

@interface SPYServiceBrowser : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (nonatomic, weak) id<SPYServiceBrowserDelegate> delegate;

@property (nonatomic, strong) NSNetServiceBrowser *browser;
@property (nonatomic, strong) NSMutableArray *servers;
@property (nonatomic, strong) NSMutableArray *serversConnections;

+(SPYServiceBrowser *)shareInstance;

@end
