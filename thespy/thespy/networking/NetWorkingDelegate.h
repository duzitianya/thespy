//
//  NetWorkingDelegate.h
//  thespy
//
//  Created by zhaoquan on 15/2/3.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SPYDelegate) {
    SPYNewPlayerPush = 10,//客户端连接后向服务端发送自身数据
    SPYNewPlayerGet = 11,//服务器端收取
    SPYAllPlayerPush = 20,//发送所有（新增）用户
    SPYAllPlayerGet = 21,//请求获得所有（新增）用户
    SPYGameRoomInfoPush = 30,//发送游戏房间信息
    SPYGameRoomInfoGet = 31,//请求获得游戏房间信息
    SPYRolePush = 40,//发送角色
    SPYRoleGet = 41,//请求角色
    SPYKillPlayerPush = 50,//杀
    SPYKillPlayerGet = 51
};

@interface NetWorkingDelegate : NSObject

+(NetWorkingDelegate *)shareInstance;

//- (void)dataOperation:(int)oper WithStream:(NSStream*)stream Step:(int)step Objects:(NSObject*)obj,...;
- (void)dataOperation:(int)oper WithStream:(NSStream*)stream Step:(int)step Objects:(NSObject*)obj;

@end
