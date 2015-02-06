//
//  NetWorkingDelegate.h
//  thespy
//
//  Created by zhaoquan on 15/2/3.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SPYDelegate) {
    SPYNewPlayer = 0,//客户端连接后向服务端发送自身数据
    SPYSetAllPlayer = 1,//发送所有（新增）用户
    SPYGetAllPlayer = 2,//请求获得所有（新增）用户
    SPYSetGameRoomInfo = 3,//发送游戏房间信息
    SPYGetGameRoomInfo = 4,//请求获得游戏房间信息
    SPYSetRole = 5,//发送角色
    SPYGetRole = 6,//请求角色
    SPYKillPlayer = 7//杀
};

@interface NetWorkingDelegate : NSObject

+(NetWorkingDelegate *)shareInstance;
- (void)dataOperation:(int)oper WithStream:(NSStream*)stream Step:(int)step;

@end
