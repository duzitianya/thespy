//
//  ActionView.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "ActionView.h"

@implementation ActionView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setUpFrame:(CGRect)frame{
    
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    NSString *serverTxt = @"创建游戏";
    CGSize size = [serverTxt sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(width/2, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.server = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, width/2-2, size.height+30-1)];
    [self.server setTitle:serverTxt forState:UIControlStateNormal];
    UIImage *serverImg = [UIImage imageNamed:@"SpyResource.bundle/server"];
    [self.server setImage:serverImg forState:UIControlStateNormal];
    [self.server addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.server setTag:1];
    self.server.layer.cornerRadius = 4;
    self.server.backgroundColor = [UIColor darkGrayColor];
    self.server.alpha = 0.6;    [self addSubview:self.server];
    
    self.client = [[UIButton alloc] initWithFrame:CGRectMake(width/2+2, 0, width/2-3, size.height+30-1)];
    [self.client setTitle:@"加入游戏" forState:UIControlStateNormal];
    UIImage *clientImg = [UIImage imageNamed:@"SpyResource.bundle/client"];
    [self.client setImage:clientImg forState:UIControlStateNormal];
    [self.client addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.client setTag:2];
    self.client.layer.cornerRadius = 4;
    self.client.backgroundColor = [UIColor grayColor];
    self.client.alpha = 0.6;
    [self addSubview:self.client];
}

- (void) buttonClick:(id)sender{
    if(sender&&[sender isKindOfClass:[UIButton class]]){
        //查看设备蓝牙状态
//        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
//        NSLog(@"BLE state...%ld", self.centralManager.state);
        
        UIButton *button = sender;
        NSInteger tag = button.tag;
        if (tag==1) {//点击的创建游戏
            [self.delegate createServer];
//            self.server.backgroundColor = [UIColor grayColor];
//            self.client.backgroundColor = [UIColor darkGrayColor];
        }else if(tag==2){
            [self.delegate asClient];
//            self.client.backgroundColor = [UIColor grayColor];
//            self.server.backgroundColor = [UIColor darkGrayColor];
        }
    }
}

+ (CGFloat) getViewHeight{
    NSString *serverTxt = @"创建游戏";
    CGSize size = [serverTxt sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kMAIN_SCREEN_WIDTH/2, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 30;
}

@end
