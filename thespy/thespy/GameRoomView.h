//
//  GameRoomView.h
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GameRoomCell.h"
#import "AppDelegate.h"
#import "PlayerBean.h"
#import "GameRoomSubview.h"
#import "GameRoomHeader.h"
#import "ServerListViewController.h"
#import "NSStream+StreamsToHost.h"
#import "SPYConnection+Delegate.h"

@interface GameRoomView : UIViewController<
        ServerListViewControllerDelegate,
        NetWorkingDelegate,
        NSStreamDelegate,
        UIAlertViewDelegate,
        NSNetServiceDelegate,
        NSNetServiceBrowserDelegate
>

@property (nonatomic) NSInteger totalNum;       //参与者总数
@property (nonatomic) NSInteger spyNum;         //卧底数
@property (nonatomic) NSInteger citizenNum;     //平民数
@property (nonatomic) NSInteger whiteBoardNum;  //白板数
@property (nonatomic, strong) PlayerBean *mainPlayer;//用户自己
@property (nonatomic, strong) NSMutableArray *otherPlayer;//其他人

@property (nonatomic, strong) UILabel *nowPlayerNum;
@property (nonatomic, strong) GameRoomSubview *subRoomView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) GameRoomHeader *gameRoomHeader;

@property (nonatomic) BOOL isServerOpen;
@property (nonatomic) BOOL asServer;//标记是否为主机
@property (nonatomic, strong) NSNetService *service;
@property (nonatomic, strong) NSMutableArray *connections;//客户端SPYConnection

@property (nonatomic, strong) SPYConnection *connection;//与主机的链接，作为客户端时不为空
@property (nonatomic, strong) ServerListViewController *plvc;
@property (nonatomic, assign) int streamOpenCount;
@property (nonatomic, assign) BOOL isRemoteInit;//是否进行过服务器注册

@property (nonatomic, assign) int remainingToRead;//网络传输的流大小

@property (nonatomic, strong) NSMutableData *mdata;

@property (nonatomic, strong) UIActivityIndicatorView* indicator;//状态指示器

- (void)setupValues:(NSInteger)totalNum SpyNum:(NSInteger)spyNum CitizenNum:(NSInteger)citizenNum WhiteboardNum:(NSInteger)whiteBoardNum MainPlayer:(PlayerBean*)mainPlayer asServer:(BOOL)asServer;

- (void) reloadClientListTable:(PlayerBean*)player;
@end
