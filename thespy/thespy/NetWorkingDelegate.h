//
//  NetWorkingDelegate.h
//  thespy
//
//  Created by zhaoquan on 15/2/10.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#ifndef thespy_NetWorkingDelegate_h
#define thespy_NetWorkingDelegate_h

@protocol NetWorkingDelegate <NSObject>
@optional
-(void)setReadLength:(int)length;
-(void)dismissViewController;//取消连接列表
-(void)reloadClientListTable:(NSArray*)list;//刷新用户列表
-(void)initGameRoomData:(NSArray*)arr;

@end

#endif
