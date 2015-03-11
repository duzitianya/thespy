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
#import "GameRoomSubview.h"
#import "GameRoomHeader.h"
#import "ServerListViewController.h"
#import "NSStream+StreamsToHost.h"
#import "SPYConnection+Delegate.h"
#import "GamePlayingViewController.h"

@class PlayerBean;

@interface GameRoomView : UIViewController<
        ServerListViewControllerDelegate,
        NetWorkingDelegate,
        NSStreamDelegate,
        UIAlertViewDelegate,
        NSNetServiceDelegate,
        NSNetServiceBrowserDelegate
>

@property (nonatomic, assign) NSInteger totalNum;       //参与者总数
@property (nonatomic, assign) NSInteger spyNum;         //卧底数
@property (nonatomic, assign) NSInteger citizenNum;     //平民数
@property (nonatomic, assign) NSInteger whiteBoardNum;  //白板数
@property (nonatomic, strong) PlayerBean *mainPlayer;//用户自己
@property (nonatomic, strong) NSMutableArray *otherPlayer;//其他人
@property (nonatomic, strong) NSString *citizenWord;//平民词语
@property (nonatomic, strong) NSString *spyWord;//卧底词语

@property (nonatomic, strong) UILabel *nowPlayerNum;
@property (nonatomic, strong) GameRoomSubview *subRoomView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) GameRoomHeader *gameRoomHeader;

@property (nonatomic, assign) BOOL isServerOpen;
@property (nonatomic, assign) BOOL asServer;//标记是否为主机
@property (nonatomic, strong) NSNetService *service;
@property (nonatomic, strong) NSMutableArray *connections;//客户端SPYConnection
@property (nonatomic, strong) SPYConnection *tempconn;//服务器接受到客户端连接后的临时存储

@property (nonatomic, strong) SPYConnection *connection;//与主机的链接，作为客户端时不为空
@property (nonatomic, strong) ServerListViewController *plvc;
@property (nonatomic, assign) int streamOpenCount;
@property (nonatomic, assign) BOOL isRemoteInit;//是否进行过服务器注册

@property (nonatomic, strong) NSMutableDictionary *readMap;//存储多线程下，每个客户端的已读数据

@property (nonatomic, strong) UIActivityIndicatorView* indicator;//状态指示器
@property (nonatomic, assign) BOOL onGame;//判断游戏是否进行中
@property (nonatomic, assign) BOOL clientAlive;//
@property (nonatomic, strong) UIButton *start;//开始游戏按钮
@property (nonatomic, assign) NSInteger readyCount;//就绪状态客户端数

@property (nonatomic, strong) UIAlertView *alert;

- (void)setupValues:(NSInteger)totalNum SpyNum:(NSInteger)spyNum CitizenNum:(NSInteger)citizenNum WhiteboardNum:(NSInteger)whiteBoardNum MainPlayer:(PlayerBean*)mainPlayer asServer:(BOOL)asServer;

- (void) reloadClientListTable:(PlayerBean*)player;

@end
