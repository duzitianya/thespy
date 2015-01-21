//
//  DBUtil.h
//  thespy
//
//  Created by zhaoquan on 15/1/21.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GameResult.h"

@interface GameDB : NSObject{
    sqlite3 *db;
}

+(GameDB *)shareInstance;

- (BOOL) addGameResult:(GameResult*)result;
- (NSArray*) historyList;

@end
