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
@synthesize id;
@synthesize word;
@synthesize role;
@synthesize status;

+ (PlayerBean*) initWithData:(NSString *)img Name:(NSString *)name ID:(NSString*)id Word:(NSString*)word {
    PlayerBean *bean = [[PlayerBean alloc] init];
    bean.img = img;
    bean.name = name;
    bean.id = id;
    bean.word = word;
    bean.status = BLE_OFFLINE;
    return bean;
}

@end
