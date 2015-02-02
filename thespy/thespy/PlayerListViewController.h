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
#import "GameRoomView.h"

@interface PlayerListViewController : UITableViewController<SPYServiceBrowserDelegate>
@property (nonatomic) NSInteger totalNum;
@property (nonatomic) NSInteger citizenNum;
@property (nonatomic) NSInteger whiteBoardNum;
@property (nonatomic) NSInteger spyNum;

@property (nonatomic, strong) SPYServiceBrowser *serverBrowser;

@end
