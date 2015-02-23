//
//  SPYConnection+Delegate.h
//  thespy
//
//  Created by zhaoquan on 15/2/9.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//
#import "SPYConnection.h"
#import "NetWorkingDelegate.h"

typedef NS_ENUM(NSInteger, SPYDelegate) {
    SPYNewPlayerPush = 1,//客户端连接后向服务端发送自身数据
    SPYNewPlayerToOtherPush = 2,//发送所有（新增）用户
    SPYGameRoomInfoPush = 3,//发送游戏房间信息
    SPYKillPlayerPush = 4,//杀
    SPYServerOutPush = 5,//服务器端退出游戏
    SPYGameStartPush = 6,//游戏开始
    SPYVictoryPush = 7,//游戏胜利
    SPYGameAgainPush = 8,//再来一局
    SYPClientLeavePush = 9//客户端离线
};

@interface SPYConnection (Delegate)

- (void)writeData:(NSOutputStream*)out WithData:(NSData*)data OperType:(SPYDelegate)oper;
- (void)operation:(SPYDelegate)oper WithData:(NSData*)data Delegate:(id<NetWorkingDelegate>)delegate;

@end
