//
//  NetWorkingDelegate.m
//  thespy
//
//  Created by zhaoquan on 15/2/3.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "NetWorkingDelegate.h"
#import "SPYConnection.h"
#import "PlayerBean.h"
 
@implementation NetWorkingDelegate{
    int remainingToRead;
}

+(NetWorkingDelegate *)shareInstance{
    static dispatch_once_t pred;
    static NetWorkingDelegate *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[NetWorkingDelegate alloc] init];
    });
    return shared;
}

- (void)dataOperation:(int)oper WithStream:(NSStream*)stream Step:(int)step{
    switch (oper) {
        case SPYGetGameRoomInfo://获取游戏房间基本信息
            break;
        case SPYGetAllPlayer://新增用户（需要获取数据长度）
            [self newPlayerArraive:stream Step:step];
            break;
        case SPYGetRole://开始游戏分发角色
            break;
        case SPYKillPlayer://杀死参与者
            break;
        default:
            break;
    }
}

- (void) initGameRoomData:(NSStream*)aStream{
    if ([aStream isKindOfClass:[NSInputStream class]]) {
        NSInputStream *in = (NSInputStream*)aStream;
        
    }
}

- (void)newPlayerArraive:(NSStream*)aStream Step:(int)step{
    NSData *data;
    if ([aStream isKindOfClass:[NSInputStream class]]) {
        NSInputStream *in = (NSInputStream*)aStream;
        if (step==2) {
            remainingToRead = [SPYConnection readGameDataDirectWithInput:in];
        }else if(remainingToRead>0&&step==3){
            data = [SPYConnection readGameDataWithInput:in size:remainingToRead];
            if (data!=nil&&[data length]==remainingToRead) {
                NSArray *arrs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if ([arrs count]>0) {
                    NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:[arrs count]];
                    for (int i=0; i<[arrs count]; i++) {
                        NSArray *a = [arrs objectAtIndex:i];
                        NSData *imgData = a[0];
                        NSString *name = a[1];
                        NSString *deviceName = a[2];
                        
                        UIImage *img = [UIImage imageWithData:imgData];
                        PlayerBean *player = [PlayerBean initWithData:img Name:name DeviceName:deviceName];
                        [temp addObject:player];
                    }
                }
                //[self reloadClientListTable:player];//刷新房间参与者列表
            }
            remainingToRead = -2;
        }
    }
}

@end
