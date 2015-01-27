//
//  SPYFileUtil.m
//  thespy
//
//  Created by zhaoquan on 15/1/27.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SPYFileUtil.h"

@implementation SPYFileUtil{
    NSString *dataDirectory;
}

+(SPYFileUtil *)shareInstance{
    static dispatch_once_t pred;
    static SPYFileUtil *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SPYFileUtil alloc] init];
    });
    return shared;
}

- (BOOL) isUserDataExist{
    NSString *dataDirectory = [NSHomeDirectory() stringByAppendingString:APP_PLAYER_DATA_HOME];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dataDirectory];
    return exist;
}

- (void) saveUserHeader:(NSData*)header{
    
}

- (void) saveUserName:(NSString*)userName{
    
}

- (NSData*) getUserHeader{
    NSString *headerDirectory = [NSHomeDirectory() stringByAppendingString:APP_PLAYER_DATA_HOME];
    NSData *headerData = [[NSFileManager defaultManager] contentsAtPath:headerDirectory];
    return headerData;
}

- (NSString*) getUserName{
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:dataDirectory];
    NSString *content = [[NSString alloc]initWithData:fileData encoding:NSUTF8StringEncoding];
    if (content) {
        return content;
    }
    return @"";
}

@end
