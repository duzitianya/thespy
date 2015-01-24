//
//  SPYService.h
//  thespy
//
//  Created by zhaoquan on 15/1/22.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SPYServiceBrowser.h"
#import "SPYConnection.h"

@protocol SPYServiceDelegate <NSObject>

@optional
- (void) reloadClientListTable;

@end

@interface SPYService : NSObject<NSNetServiceDelegate, NSStreamDelegate>

@property (nonatomic, strong) NSNetService *server;
@property (nonatomic, strong) NSMutableArray *clients;
//@property (nonatomic, strong) NSMutableArray *clientsConnections;
@property (nonatomic, strong) SPYConnection *connection;
@property (nonatomic) BOOL isServerOpen;

+(SPYService *)shareInstance;
- (void) publishServer;

@end
