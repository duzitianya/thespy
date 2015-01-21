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

- (id) initWithName:(NSString*)name Role:(NSString*)role Victory:(NSString*)victory{
    self = [super init];
    if (self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [NSDate date];
        //当前时间到1970年值
        NSTimeInterval time = [date timeIntervalSince1970];
        
        self._playerid = [NSString stringWithFormat:@"%lf", time];
        self._name = name;
        self._role = role;
        self._victory = victory;
        self._date = [formatter stringFromDate:date];
    }
    return self;
}

- (id) initWithPlayerID:(NSString*)playerID Name:(NSString*)name Role:(NSString*)role Victory:(NSString*)victory Date:(NSString*)date{
    self = [super init];
    if (self) {
        
        self._playerid = playerID;
        self._name = name;
        self._role = role;
        self._victory = victory;
        self._date = date;
    }
    return self;
}

@end
