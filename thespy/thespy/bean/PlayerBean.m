//
//  PlayerBean.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerBean.h"

@implementation PlayerBean
@synthesize img;
@synthesize name;
@synthesize deviceName;
@synthesize word;
@synthesize role;
@synthesize status;
@synthesize connection;

+ (PlayerBean*) initWithData:(UIImage *)img Name:(NSString *)name DeviceName:(NSString*)deviceName {
    PlayerBean *bean = [[PlayerBean alloc] init];
    bean.img = img;
    bean.name = name;
    bean.deviceName = deviceName;
    bean.status = BLE_OFFLINE;
    return bean;
}

@end
