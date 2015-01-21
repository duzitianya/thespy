//
//  GameResult.m
//  thespy
//
//  Created by zhaoquan on 15/1/21.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameResult.h"

@implementation GameResult
@synthesize _playerid;
@synthesize _name;
@synthesize _role;
@synthesize _victory;
@synthesize _date;

- (id) initWithID:(NSString*)playerid Name:(NSString*)name Role:(NSString*)role Victory:(NSString*)victory Date:(NSString*)date{
    self = [super init];
    if (self) {
        //当前时间到1970年值
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        self._playerid = [NSString stringWithFormat:@"%lf", time];
        self._name = name;
        self._role = role;
        self._victory = victory;
        self._date = date;
    }
    return self;
}

@end
