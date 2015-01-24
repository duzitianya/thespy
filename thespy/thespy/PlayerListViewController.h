//
//  PlayerListViewController.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPYServiceBrowser.h"
#import "SPYService.h"

@interface PlayerListViewController : UITableViewController<SPYServiceDelegate, SPYServiceBrowserDelegate>

@property (nonatomic, strong) SPYService *server;
@property (nonatomic, strong) SPYServiceBrowser *serverBrowser;
@property (nonatomic, strong) NSArray *playerList;
@property (nonatomic) BOOL isServer;

@end
