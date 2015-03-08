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
    UIImage *header = [[UIImage alloc]initWithData:headerData];
    if (header==nil) {
        header = [UIImage imageNamed:@"SpyResource.bundle/headdefault.png"];
    }
    return header;
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

- (NSArray*) getWords{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSNumber *allCount = [data objectForKey:@"words_count"];
    NSNumber *average = [data objectForKey:@"average_value"];
    NSArray *words = [data objectForKey:@"words"];
    NSString *citizen;
    NSString *spy;
    for (int i=0; i<[words count]; i++) {//忽略随机数出现的重复概率
        NSInteger value = arc4random() % [allCount integerValue];
        NSDictionary *dict = words[value];
        NSDate *date = [dict objectForKey:@"date"];
        NSNumber *times = [dict objectForKey:@"times"];
        citizen = [dict objectForKey:@"citizen"];
        spy = [dict objectForKey:@"spy"];
        //如果使用次数大于平均值一次或者6小时使用过，需要更换词语
//        NSLog(@"=================%f===============", [date timeIntervalSinceNow]);
        if (([times doubleValue]-[average doubleValue])<=1&&[date timeIntervalSinceNow]>3600*6*-1) {
            break;
        }
    }
    
    [self updateWordsPlayTimes:0 Words:words Dict:data];
    
    NSArray *arr = [[NSArray alloc]initWithObjects:citizen, spy, nil];
    return arr;
}



- (void) updateWordsPlayTimes:(NSInteger)index Words:(NSArray*)words Dict:(NSMutableDictionary*)data{
    double total = 0.;
    if (words) {
        for (int i=0; i<[words count]; i++) {
            NSDictionary *dict = words[i];
            NSNumber *times = [dict objectForKey:@"times"];
            total += [times integerValue];
            if (i==index) {
                total++;
                [dict setValue:[[NSNumber alloc]initWithInteger:[times integerValue]+1] forKey:@"times"];
                [dict setValue:[NSDate date] forKey:@"date"];
            }
        }
    }
    NSNumber *avg = [[NSNumber alloc]initWithDouble:(total/[words count])];
    [data setObject:avg forKey:@"average_value"];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    [data writeToFile:plistPath atomically:YES];
}

@end
