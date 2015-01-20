//
//  ActionView.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "ActionView.h"

@implementation ActionView

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//    }
//    return self;
//}

- (void)setUpFrame:(CGRect)frame{
    self.frame = frame;
    self.backgroundColor = [UIColor blackColor];
    
    UIButton *server = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
    [server setTitle:@"创建游戏" forState:UIControlStateNormal];
    [server addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [server setTag:1];
    server.backgroundColor = [UIColor blueColor];
    server.layer.cornerRadius = 2;
    [self addSubview:server];
    
    UIButton *client = [[UIButton alloc] initWithFrame:CGRectMake(100, 140, 20, 20)];
    [client setTitle:@"加入游戏" forState:UIControlStateNormal];
    [client addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [client setTag:2];
    [self addSubview:client];

}

- (void) buttonClick:(id)sender{
    if(sender&&[sender isKindOfClass:[UIButton class]]){
        UIButton *button = sender;
        NSInteger tag = button.tag;
        if (tag==1) {
            [self.delegate createServer];
        }else if(tag==2){
            [self.delegate asClient];
        }
    }
}

@end
