//
//  DBUtil.m
//  thespy
//
//  Created by zhaoquan on 15/1/21.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameDB.h"

@implementation GameDB

+(GameDB *)shareInstance{
    static dispatch_once_t pred;
    static GameDB *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[GameDB alloc] init];
    });
    return shared;
}

- (id)init{
    self  = [super init];
    if (self) {
        NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *databaseFilePath = [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent: @"SPY_GAME"];
        if (sqlite3_open([databaseFilePath UTF8String], &db)!=SQLITE_OK) {//初始化失败则关闭
            sqlite3_close(db);
        }else{
            [self createTable:@"T_SPY_GAME_HISTORY"];
        }
    }
    
    return self;
}

- (BOOL) createTable:(NSString*)table_name{
    char *errorMsg;
    NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS T_SPY_GAME_HISTORY (ID INTEGER PRIMARY KEY, NAME TEXT, ROLE TEXT, VICTORY TEXT, DATE TEXT);";
    if (sqlite3_exec (db, [createTableSQL  UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) {
//        sqlite3_close(db);
        return NO;
    }
    return YES;
}

- (BOOL) addGameResult:(GameResult*)result {
    char *err;
    NSString *insertSQL = @"INSERT INTO T_SPY_GAME_HISTORY VALUES(%@,%@,%@,%@,%@)";
    insertSQL = [NSString stringWithFormat:insertSQL, result._playerid, result._name, result._role, result._victory, result._date];
    if (sqlite3_exec(db, [insertSQL UTF8String], NULL, NULL, &err)) {
        return NO;
    }
    return YES;
}


@end
