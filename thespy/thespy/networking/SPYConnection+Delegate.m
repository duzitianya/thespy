//
//  SPYConnection+Delegate.m
//  thespy
//
//  Created by zhaoquan on 15/2/9.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SPYConnection+Delegate.h"
#import "PlayerBean.h"
#import "SPYFileUtil.h"

@implementation SPYConnection (Delegate)

- (void)dataOperation:(int)oper WithStream:(NSStream*)stream Objects:(NSObject*)obj Delegate:(id<NetWorkingDelegate>)delegate{
    self.netDelegate = delegate;
    switch (oper) {
        case SPYNewPlayerPush://客户端连接后向服务端发送自身数据
            [self newPlayerPush:stream WithPlayer:(PlayerBean*)obj];
            break;
        case SPYNewPlayerGet://服务器端收取
            if ([obj isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray*)obj;
                [self newPlayerArraive:stream Step:[(NSString*)arr[0] intValue] ReadLength:[(NSString*)arr[1] intValue]];
            }
            break;
        case SPYNewPlayerToOtherPush://发送所有（新增）用户
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary*)obj;
                NSArray *conns = [dict objectForKey:@"conn"];
                PlayerBean *bean = [dict objectForKey:@"player"];
                [self pushNewPlayerToOthers:conns WithPlayer:bean];
            }
            break;
        case SPYNewPlayerToOtherGet://请求获得所有（新增）用户
            if ([obj isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray*)obj;
                [self newPlayerArraive:stream Step:[(NSString*)arr[0] intValue] ReadLength:[(NSString*)arr[1] intValue]];
            }
            break;
        case SPYGameRoomInfoPush://发送游戏房间信息
            [self gameRoomDataPush:stream WithData:(NSData*)obj];
            break;
        case SPYGameRoomInfoGet://请求获得游戏房间信息
            [self gameRoomDataRead:stream];
            break;
        case SPYRolePush://发送角色
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary*)obj;
                NSArray *conns = [dict objectForKey:@"conn"];
                NSArray *roles = [dict objectForKey:@"roles"];
                [self pushRole:conns Roles:roles];
            }
            break;
        case SPYRoleGet://请求角色
            [self getRole:stream];
            break;
        case SPYKillPlayerPush://杀
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary*)obj;
                NSArray *conns = [dict objectForKey:@"conn"];
                NSString *index = [dict objectForKey:@"index"];
                [self killPlayer:conns WithIndex:[index intValue]];
            }
            break;
        case SPYKillPlayerGet:
            [self getKilledPlayer:stream WithIndex:(NSInteger)obj];
            break;
        case SPYAllPlayerPush:
            [self allPlayerPush:stream WithAllPlayer:(NSArray*)obj];
            break;
        case SPYAllPlayerGet:
            if ([obj isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray*)obj;
                [self allPlayerGet:stream Step:[(NSString*)arr[0] intValue] ReadLength:[(NSString*)arr[1] intValue]];
            }
            break;
        default:
            break;
    }
}

//杀掉指定用户
- (void)killPlayer:(NSArray*)connections WithIndex:(NSInteger)index{
    if (connections!=nil) {
        for (int i=0; i<[connections count]; i++) {
            SPYConnection *conn = connections[i];
            NSOutputStream *out = conn.output;
            [SPYConnection writeOperationType:out OperType:SPYKillPlayerPush];
            uint8_t buf[1];
            buf[0] = index;
            [out write:buf maxLength:sizeof(buf)];
        }
    }
}

- (void)getKilledPlayer:(NSStream*)stream WithIndex:(NSInteger)index{
    if ([stream isKindOfClass:[NSInputStream class]]) {
        NSInputStream *in = (NSInputStream*)stream;
        uint8_t buf[1];
        long length = [in read:buf maxLength:sizeof(buf)];
        if (length>0) {
            NSInteger index = buf[0];
            
        }
    }
}

//为所有客户端初始化角色
- (void)pushRole:(NSArray*)connections Roles:(NSArray*)role{
    if (connections!=nil) {
        for (int i=0; i<[connections count]; i++) {
            SPYConnection *conn = connections[i];
            NSOutputStream *out = conn.output;
            [SPYConnection writeOperationType:out OperType:SPYRolePush];
            uint8_t buf[1];
            buf[0] = (int)role[i];
            [out write:buf maxLength:sizeof(buf)];
        }
    }
}

- (void)getRole:(NSStream*)stream{
    if ([stream isKindOfClass:[NSInputStream class]]) {
        NSInputStream *in = (NSInputStream*)stream;
        uint8_t buf[1];
        int role;
        long length = [in read:buf maxLength:sizeof(buf)];
        if (length==1) {
            role = buf[0];
        }
    }
}

//将新用户注册到其他用户
- (void)pushNewPlayerToOthers:(NSArray*)spyconnections WithPlayer:(PlayerBean*)bean{
    if (spyconnections!=nil) {
        for (int i=0; i<[spyconnections count]; i++) {
            SPYConnection *conn = spyconnections[i];
            NSOutputStream *out = conn.output;
            [SPYConnection writeOperationType:out OperType:SPYNewPlayerPush];
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
        [self.netDelegate initGameRoomData:data];
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
        [self.netDelegate dismissViewController];
    }
}

//获得新连接用户数据
- (void)newPlayerArraive:(NSStream*)aStream Step:(int)step ReadLength:(int)length{
    NSData *data;
    if ([aStream isKindOfClass:[NSInputStream class]]) {
        NSInputStream *in = (NSInputStream*)aStream;
        if (step==2) {
            int remainingToRead = [SPYConnection readGameDataDirectWithInput:in];
            [self.netDelegate setReadLength:remainingToRead];
        }else if(length>0&&step==3){
            data = [SPYConnection readGameDataWithInput:in size:length];
            if (data!=nil&&[data length]==length) {
                NSArray *arrs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if ([arrs count]>0) {
                    NSData *imgData = arrs[0];
                    NSString *name = arrs[1];
                    NSString *deviceName = arrs[2];
                    
                    UIImage *img = [UIImage imageWithData:imgData];
                    PlayerBean *player = [PlayerBean initWithData:img Name:name DeviceName:deviceName];
                    NSArray *list = [[NSArray alloc]initWithObjects:player, nil];
                    [self.netDelegate reloadClientListTable:list];//刷新房间参与者列表
                }
            }
        }
    }
}

- (void)allPlayerPush:(NSStream*)stream WithAllPlayer:(NSArray*)all{
    if ([stream isKindOfClass:[NSOutputStream class]]) {
        NSOutputStream *out = (NSOutputStream*)stream;
        NSData *sendData = [NSKeyedArchiver archivedDataWithRootObject:all];
        NSInteger length = [SPYConnection writeData:sendData withStream:out];
    }
}

- (void)allPlayerGet:(NSStream*)stream Step:(int)step ReadLength:(int)length{
    NSData *data;
    if ([stream isKindOfClass:[NSInputStream class]]) {
        NSInputStream *in = (NSInputStream*)stream;
        if (step==2) {
            int length = [SPYConnection readGameDataDirectWithInput:in];
            [self.netDelegate setReadLength:length];
        }else if(length>0&&step==3){
            data = [SPYConnection readGameDataWithInput:in size:length];
            if (data!=nil&&[data length]==length) {
                NSArray *arrs = [NSKeyedUnarchiver unarchiveObjectWithData:data];//全部封装PlayerBean
                if ([arrs count]>0) {
                    [self.netDelegate reloadClientListTable:arrs];//刷新房间参与者列表
                }
            }
        }
    }
}



@end
