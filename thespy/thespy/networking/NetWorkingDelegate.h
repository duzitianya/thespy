//
//  NetWorkingDelegate.h
//  thespy
//
//  Created by zhaoquan on 15/2/3.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SPYDelegate) {
    SPYGetNewPlayer = 0,
    SPYGetGameRoomInfo = 1,
    SPYGetAllPlayer = 2,
    SPYGetRole = 3,
    SPYKillPlayer = 4
};

@interface NetWorkingDelegate : NSObject

@property (nonatomic) SPYDelegate spyDelegate;


@end
