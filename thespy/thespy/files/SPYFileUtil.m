//
//  SPYFileUtil.m
//  thespy
//
//  Created by zhaoquan on 15/1/27.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SPYFileUtil.h"

@implementation SPYFileUtil

+(SPYFileUtil *)shareInstance{
    static dispatch_once_t pred;
    static SPYFileUtil *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SPYFileUtil alloc] init];
        NSString *dataDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents/thespy"];
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dataDirectory];
        if (!exist) {
            BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dataDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return shared;
}

- (BOOL) isUserDataExist{
    
    NSString *dataDirectory = [NSHomeDirectory() stringByAppendingString:APP_PLAYER_DATA_HOME];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dataDirectory];
    return exist;
}

- (void) saveUserHeader:(UIImage*)header{
    NSString *dataDirectory = [NSHomeDirectory() stringByAppendingString:APP_PLAYER_HEADER];
    [UIImageJPEGRepresentation(header, 1.0f) writeToFile:dataDirectory atomically:YES];//写入文件
}

- (void) saveUserName:(NSString*)userName{
    NSString *dataDirectory = [NSHomeDirectory() stringByAppendingString:APP_PLAYER_DATA_HOME];
    BOOL success = [[NSFileManager defaultManager] createFileAtPath:dataDirectory contents:[userName dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

- (UIImage*) getUserHeader{
    NSString *headerDirectory = [NSHomeDirectory() stringByAppendingString:APP_PLAYER_HEADER];
    NSData *headerData = [[NSFileManager defaultManager] contentsAtPath:headerDirectory];
    return [[UIImage alloc]initWithData:headerData];
}

- (NSString*) getUserName{
    NSString *dataDirectory = [NSHomeDirectory() stringByAppendingString:APP_PLAYER_DATA_HOME];
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:dataDirectory];
    NSString *content = [[NSString alloc]initWithData:fileData encoding:NSUTF8StringEncoding];
    if (content) {
        return content;
    }
    return @"";
}

@end
