//
//  PlayerBean.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPYConnection.h"
//#import <UIKit/UIKit.h>

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

@class UIImage;

@interface PlayerBean : NSObject

@property (nonatomic, strong) UIImage *img;         //头像
@property (nonatomic, weak) NSString *name;         //昵称
@property (nonatomic, weak) NSString *deviceName;   //设备名称
@property (nonatomic, strong) NSString *word;       //词条
@property (nonatomic) PlayerOnlineStatus status;    //状态
@property (nonatomic) PlayerRole role;         //角色
@property (nonatomic, strong) SPYConnection *connection;//与服务器的链接

+ (PlayerBean*) initWithData:(UIImage *)img Name:(NSString *)name DeviceName:(NSString*)deviceName;

@end
