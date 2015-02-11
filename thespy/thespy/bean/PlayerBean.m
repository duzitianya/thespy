//
//  PlayerBean.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerBean.h"

#define HEADER @"header"
#define NAME @"name"
#define DEVICE @"deviceName"
#define WORD @"word"
#define ROLE @"role"
#define STATUS @"status"

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

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:img forKey:HEADER];
    [aCoder encodeObject:name forKey:NAME];
    [aCoder encodeObject:deviceName forKey:DEVICE];
    [aCoder encodeObject:word forKey:WORD];
    [aCoder encodeInteger:role forKey:ROLE];
    [aCoder encodeInteger:status forKey:STATUS];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self!=nil) {
        img = [[aDecoder decodeObjectForKey:HEADER]copy];
        name = [[aDecoder decodeObjectForKey:NAME]copy];
        deviceName = [[aDecoder decodeObjectForKey:DEVICE]copy];
        word = [[aDecoder decodeObjectForKey:WORD]copy];
        role = [aDecoder decodeIntegerForKey:ROLE];
        status = [aDecoder decodeIntegerForKey:STATUS];
    }
    return self;
}

@end
