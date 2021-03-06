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

- (void)writeData:(NSOutputStream*)out WithData:(NSData*)data OperType:(SPYDelegate)oper{
    //将数据长度写入传送数据前
    NSInteger olength = [data length]+4+1;//+4:4字节的数据长度占位；+1:1字节操作类型占位
    uint8_t databuf[4];
    for(int i = 0;i<4;i++){
        databuf[i] = (Byte)(olength>>8*(3-i)&0xff);
    }
    NSMutableData *mdata = [NSMutableData dataWithBytes:databuf length:sizeof(databuf)];
    
    //将操作类型加入到传送数据前
    uint8_t buf[1];
    buf[0] = (Byte)(oper&0xff);
    [mdata appendBytes:buf length:sizeof(buf)];
    
    //合并生成新数据
    [mdata appendData:data];
    NSInteger length = [mdata length];
    uint8_t total[length];
    [mdata getBytes:total length:sizeof(total)];
    [out write:total maxLength:sizeof(total)];//写出数据
}

- (void)operation:(SPYDelegate)oper WithData:(NSData*)data Delegate:(id<NetWorkingDelegate>)delegate{
    self.netDelegate = delegate;
    switch (oper) {
        case SPYNewPlayerPush:{
            PlayerBean *bean = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSArray *arr = [NSArray arrayWithObjects:bean, nil];
            [self.netDelegate reloadClientListTable:arr];
            break;
        }
        case SPYGameRoomInfoPush:{
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSArray *arr = [dict objectForKey:@"roomarr"];
            [self.netDelegate initGameRoomData:arr];
            NSArray *players = [dict objectForKey:@"players"];
            [self.netDelegate reloadClientListTable:players];
            break;
        }
        default:
            break;
    }
}

@end
