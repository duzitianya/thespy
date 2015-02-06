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
#import "SPYFileUtil.h"
 
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

- (void)dataOperation:(int)oper WithStream:(NSStream*)stream Step:(int)step Objects:(NSObject*)obj,...{
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

//杀掉指定用户
- (void)killPlayer:(NSStream*)aStream{
    if ([aStream isKindOfClass:[NSOutputStream class]]) {
        uint8_t buf[1];
        buf[0] = '1';
        NSOutputStream *out = (NSOutputStream*)aStream;
        [out write:buf maxLength:sizeof(buf)];
    }
}

//为所有客户端初始化角色
- (void)pushRole:(NSArray*)connections Roles:(NSArray*)role{
    if (connections!=nil) {
        for (int i=0; i<[connections count]; i++) {
            SPYConnection *conn = connections[i];
            NSOutputStream *out = conn.output;
            uint8_t buf[1];
            buf[0] = (int)role[i];
            [out write:buf maxLength:sizeof(buf)];
        }
    }
}

//将新用户注册到其他用户
- (void)pushNewPlayerToOthers:(NSArray*)spyconnections ignoreStream:(NSStream*)aStream WithPlayer:(PlayerBean*)bean{
    if (spyconnections!=nil) {
        for (int i=0; i<[spyconnections count]; i++) {
            SPYConnection *conn = spyconnections[i];
            NSOutputStream *out = conn.output;
            NSInputStream *in = conn.input;
            if([out isEqual:aStream]||[in isEqual:aStream]){
                continue;
            }
            [self newPlayerPush:out WithPlayer:bean];
        }
    }
}

//发送游戏房间基本数据
- (void)gameRoomDataPush:(NSStream*)aStream WithData:(NSData*)data{
    if ([aStream isKindOfClass:[NSOutputStream class]]) {
        NSOutputStream *out = (NSOutputStream*)aStream;
        uint8_t buf[32768];
        [data getBytes:buf length:[data length]];
        [out write:buf maxLength:sizeof(buf)];
    }
}

//读取游戏房间基本数据
- (void)gameRoomDataRead:(NSStream*)aStream{
    if ([aStream isKindOfClass:[NSOutputStream class]]) {
        uint8_t buf[32768];
        NSInputStream *in = (NSInputStream*)aStream;
        NSInteger length = [in read:buf maxLength:sizeof(buf)];
        NSData *data = [NSData dataWithBytes:buf length:length];
    }
}

//新客户端连接后发送本机数据
- (void)newPlayerPush:(NSStream*)aStream WithPlayer:(PlayerBean*)bean{
    //发送本机数据
    UIImage *img = bean.img;//头像数据
    NSString *name = bean.name;//用户名
    NSString *deviceName = bean.deviceName;
    NSArray *arr = [NSArray arrayWithObjects:UIImagePNGRepresentation(img), name, deviceName, nil];
    NSData *sendData = [NSKeyedArchiver archivedDataWithRootObject:arr];
    NSInteger length = [SPYConnection writeData:sendData withStream:(NSOutputStream*)aStream];
    if (length==[sendData length]) {
//        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

//获得新连接用户数据
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
