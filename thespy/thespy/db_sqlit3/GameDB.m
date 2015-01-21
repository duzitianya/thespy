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
    NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS T_SPY_GAME_HISTORY (ID TEXT PRIMARY KEY, NAME TEXT, ROLE TEXT, VICTORY TEXT, DATE TEXT);";
    if (sqlite3_exec (db, [createTableSQL  UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) {
//        sqlite3_close(db);
        NSLog(@"createTable error... %s", errorMsg);
        return NO;
    }
    return YES;
}

- (BOOL) addGameResult:(GameResult*)result {
    char *err;
    NSString *insertSQL = @"INSERT INTO T_SPY_GAME_HISTORY(ID, NAME, ROLE, VICTORY, DATE) VALUES('%@','%@','%@','%@','%@')";
    insertSQL = [NSString stringWithFormat:insertSQL, result._playerid, result._name, result._role, result._victory, result._date];
    if (sqlite3_exec(db, [insertSQL UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
        NSLog(@"addGameResult error... %s", err);
        return NO;
    }
    return YES;
}

- (NSArray*) historyList{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:10];
    
    NSString *selectSQL = @"SELECT * FROM T_SPY_GAME_HISTORY";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [selectSQL UTF8String], -1, nil, nil) == SQLITE_OK)  {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            int num_cols = sqlite3_column_count(stmt);//计算有多少列
            if (num_cols > 0) {
                NSString *playerID, *name, *role, *victory, *date;
                for (int i=0; i<num_cols; i++) {
                    const char *col_name = sqlite3_column_name(stmt, i);//获得列名
                    if (col_name) {
                        NSString *colName = [NSString stringWithUTF8String:col_name];
                        if (sqlite3_column_type(stmt, i)==SQLITE_TEXT) {//判断列数据类型
                            char *c_value = (char *)sqlite3_column_text(stmt, i);//获取列数据
                            NSString *value = [[NSString alloc] initWithUTF8String:c_value];
                            if ([colName isEqualToString:@"ID"]) {
                                playerID = value;
                            }else if([colName isEqualToString:@"NAME"]){
                                name = value;
                            }else if([colName isEqualToString:@"ROLE"]){
                                role = value;
                            }else if([colName isEqualToString:@"VICTORY"]){
                                victory = value;
                            }else{
                                date = value;
                            }
                        }
                    }
                }
                GameResult *r = [[GameResult alloc] initWithPlayerID:playerID Name:name Role:role Victory:victory Date:date];
                [result addObject:r];
            }
            
        }
    }
    sqlite3_finalize(stmt);
    return result;
}


@end
