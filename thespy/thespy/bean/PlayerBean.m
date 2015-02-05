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

+ (PlayerBean*) initWithData:(UIImage *)img Name:(NSString *)name DeviceName:(NSString*)deviceName {
    NSString *dname = [UIDevice currentDevice].name;
    PlayerBean *bean = [[PlayerBean alloc] init];
    bean.img = img;
    if (name==nil||[name length]==0) {
        name = dname;
    }
    bean.name = name;
    if (deviceName==nil||[deviceName length]==0) {
        deviceName = dname;
    }
    bean.deviceName = deviceName;
    bean.status = BLE_OFFLINE;
    return bean;
}

@end
