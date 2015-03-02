//
//  PlayerBean.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PlayerOnlineStatus){
    BLE_ONLINE = 0,//在线
    BLE_OFFLINE = 1,//离线
    BLE_CONNECTTING = 2//正在链接
};

//游戏角色定义
typedef NS_ENUM(NSInteger, PlayerRole){
    SPY = 0,//卧底
    CITIZEN = 1,//平民
    WHITE = 2//白板
};

@class UIImage;
@class SPYConnection;

@interface PlayerBean : NSObject<NSCoding>

@property (nonatomic, strong) NSString *uuid;   //唯一标识
@property (nonatomic, strong) UIImage *img;         //头像
@property (nonatomic, strong) NSString *name;         //昵称
@property (nonatomic, strong) NSString *deviceName;   //设备名称
@property (nonatomic, strong) NSString *word;       //词条
@property (nonatomic, strong) NSNumber *index;//游戏开始后本机所在成员列表位置
@property (nonatomic, assign) PlayerOnlineStatus status;    //状态
@property (nonatomic, assign) PlayerRole role;         //角色
@property (nonatomic, strong) SPYConnection *connection;

+ (PlayerBean*) initWithData:(UIImage *)img Name:(NSString *)name DeviceName:(NSString*)deviceName BeanID:(NSString*)uuid;
+ (NSString*)getRoleStringByPlayerRole:(PlayerRole)role;

@end
