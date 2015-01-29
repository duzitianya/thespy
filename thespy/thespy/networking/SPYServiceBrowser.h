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
- (void) connectServerSuccessful;
@end

@interface SPYServiceBrowser : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (nonatomic, weak) id<SPYServiceBrowserDelegate> delegate;

@property (nonatomic, strong) NSNetService *service;
@property (nonatomic, strong) NSNetServiceBrowser *browser;
@property (nonatomic, strong) NSMutableArray *servers;//SPYService
@property (nonatomic, strong) SPYConnection *connection;//SPYConnection

+(SPYServiceBrowser *)shareInstance;
- (void) browseService;
- (void) connectNSServer:(NSInteger)index;

@end
