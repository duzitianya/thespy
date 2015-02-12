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
    SPYNewPlayerPush = 10,//客户端连接后向服务端发送自身数据
    SPYNewPlayerGet = 11,//服务器端收取
    SPYNewPlayerToOtherPush = 20,//发送所有（新增）用户
    SPYNewPlayerToOtherGet = 21,//请求获得所有（新增）用户
    SPYGameRoomInfoPush = 30,//发送游戏房间信息
    SPYGameRoomInfoGet = 31,//请求获得游戏房间信息
    SPYRolePush = 40,//发送角色
    SPYRoleGet = 41,//请求角色
    SPYKillPlayerPush = 50,//杀
    SPYKillPlayerGet = 51,
    SPYAllPlayerPush = 60,//将已经注册的所有用户推送到新注册用户
    SPYAllPlayerGet = 61,
    SPYServerOutPush = 71//服务器端退出游戏
};

@interface SPYConnection (Delegate)

- (void)writeData:(NSOutputStream*)out WithData:(NSData*)data OperType:(SPYDelegate)oper;
- (void)operation:(SPYDelegate)oper WithData:(NSData*)data Delegate:(id<NetWorkingDelegate>)delegate;

@end
