//
//  PlayerBean.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerBean.h"

#define UUID @"uuid"
#define HEADER @"header"
#define NAME @"name"
#define DEVICE @"deviceName"
#define WORD @"word"
#define ROLE @"role"
#define STATUS @"status"
#define INDEX @"index"

@implementation PlayerBean
@synthesize uuid;
@synthesize img;
@synthesize name;
//@synthesize deviceName;
@synthesize word;
@synthesize role;
@synthesize status;
@synthesize connection;
@synthesize index;

+ (PlayerBean*) initWithData:(UIImage *)img Name:(NSString *)name BeanID:(NSString*)uuid{
//    NSString *dname = [UIDevice currentDevice].name;
    PlayerBean *bean = [[PlayerBean alloc] init];
    bean.uuid = uuid;
    bean.img = img;
    if (name==nil||[name length]==0) {
        name = @"";
    }
    bean.name = name;
//    if (deviceName==nil||[deviceName length]==0) {
//        deviceName = dname;
//    }
//    bean.deviceName = deviceName;
    bean.status = BLE_CONNECTTING;
    return bean;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:uuid forKey:UUID];
    [aCoder encodeObject:img forKey:HEADER];
    [aCoder encodeObject:name forKey:NAME];
//    [aCoder encodeObject:deviceName forKey:DEVICE];
    [aCoder encodeObject:word forKey:WORD];
    [aCoder encodeInteger:role forKey:ROLE];
    [aCoder encodeInteger:status forKey:STATUS];
    [aCoder encodeObject:index forKey:INDEX];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self!=nil) {
        uuid = [[aDecoder decodeObjectForKey:UUID]copy];
        img = [[aDecoder decodeObjectForKey:HEADER]copy];
        name = [[aDecoder decodeObjectForKey:NAME]copy];
//        deviceName = [[aDecoder decodeObjectForKey:DEVICE]copy];
        word = [[aDecoder decodeObjectForKey:WORD]copy];
        role = [aDecoder decodeIntegerForKey:ROLE];
        status = [aDecoder decodeIntegerForKey:STATUS];
        index = [aDecoder decodeObjectForKey:INDEX];
    }
    return self;
}

+(NSString*)getRoleStringByPlayerRole:(PlayerRole)role{
    NSString *r = @"平 民";
    switch (role) {
        case SPY:
            r = @"卧 底";
            break;
        case CITIZEN:
            r = @"平 民";
            break;
        case WHITE:
            r = @"白 板";
        default:
            r = @"平 民";
            break;
    }
    return r;
}

@end
