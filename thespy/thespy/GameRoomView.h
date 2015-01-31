//
//  GameRoomView.h
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRoomCell.h"
#import "AppDelegate.h"
#import "PlayerBean.h"
#import "GameRoomSubview.h"
#import "PlayerListViewController.h"
#import "SPYService.h"
#import "GameRoomHeader.h"

@interface GameRoomView : UIViewController<SPYServiceDelegate, UIAlertViewDelegate>
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

@property (nonatomic) BOOL asServer;//标记是否为主机
@property (nonatomic, strong) SPYService *server;//作为主机时不为空
@property (nonatomic, strong) NSArray *connections;//客户端SPYConnection

@property (nonatomic, strong) SPYConnection *connection;//与主机的链接，作为客户端时不为空

- (void)setupValues:(NSInteger)totalNum SpyNum:(NSInteger)spyNum CitizenNum:(NSInteger)citizenNum WhiteboardNum:(NSInteger)whiteBoardNum MainPlayer:(PlayerBean*)mainPlayer asServer:(BOOL)asServer;

@end
