//
//  PlayerBean.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>

//当前链接状态类型
typedef enum {
    BLE_ONLINE,//在线
    BLE_OFFLINE,//离线
    BLE_CONNECTTING//正在链接
}PlayerOnlineStatus;

//游戏角色定义
typedef enum{
    SPY,//卧底
    CITIZEN,//平民
    WHITE//白板
}PlayerRole;

@interface PlayerBean : NSObject

@property (nonatomic, strong) NSString *img;    //头像
@property (nonatomic, weak) NSString *name;     //昵称
@property (nonatomic, weak) NSString *id;       //唯一标识
@property (nonatomic, strong) NSString *word;   //词条
@property (nonatomic) PlayerOnlineStatus status;//状态
@property (nonatomic) PlayerRole role;         //角色

+ (PlayerBean*) initWithData:(NSString *)img Name:(NSString *)name ID:(NSString*)id Word:(NSString*)word;

@end