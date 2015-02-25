//
//  NetWorkingDelegate.h
//  thespy
//
//  Created by zhaoquan on 15/2/10.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#ifndef thespy_NetWorkingDelegate_h
#define thespy_NetWorkingDelegate_h
#import "PlayerBean.h"

@protocol NetWorkingDelegate <NSObject>
@optional
-(void)dismissViewController;//取消连接列表
-(void)reloadClientListTable:(NSArray*)list;//刷新用户列表
-(void)initGameRoomData:(NSArray*)arr;
-(void)serverIsOut;
-(void)startRemoteGame:(PlayerBean*)bean;
-(void)killPlayerWithArr:(NSArray*)arr;
-(void)victory:(NSNumber*)type;
-(void)gameAgain;
-(void)clientLeave:(NSNumber*)index;
-(void)confirmPlayerNumber:(NSNumber*)allCount;
-(void)validatePlayerList:(NSMutableArray*)list Number:(NSNumber*)number;

@end

#endif
