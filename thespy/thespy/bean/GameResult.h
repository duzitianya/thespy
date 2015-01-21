//
//  GameResult.h
//  thespy
//
//  Created by zhaoquan on 15/1/21.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

@property (nonatomic, weak) NSString *_playerid;
@property (nonatomic, weak) NSString *_name;
@property (nonatomic, weak) NSString *_role;
@property (nonatomic, weak) NSString *_victory;
@property (nonatomic, weak) NSString *_date;

- (id) initWithName:(NSString*)name Role:(NSString*)role Victory:(NSString*)victory;
- (id) initWithPlayerID:(NSString*)playerID Name:(NSString*)name Role:(NSString*)role Victory:(NSString*)victory Date:(NSString*)date;

@end
