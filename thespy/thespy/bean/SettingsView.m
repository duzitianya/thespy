//
//  SettingsView.m
//  thespy
//
//  Created by zhaoquan on 15/1/24.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView

- (void)awakeFromNib{
//    CGFloat x = _headImg.frame.origin.x;
//    CGFloat y = _headImg.frame.origin.y;
//    CGFloat width = _headImg.frame.size.width;
//    CGFloat height = _headImg.frame.size.height;
//    
//    _headImg.layer.borderWidth = 1;
//    _headImg.layer.borderColor = [[UIColor greenColor] CGColor];
//    _headImg.layer.cornerRadius = height/2;
////    _headImg.layer.masksToBounds = YES;
//    _headImg.alpha = 0;
//    
//    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
//    confirmButton.layer.cornerRadius = height/2;
//    confirmButton.alpha = 0;
//    [confirmButton addTarget:self action:@selector(confirmHeadImg:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (instancetype) init{
    self = [super init];
    if (self) {
        [self setupFrame];
    }
    return self;
}

- (void) setupFrame{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, 85)];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, kMAIN_SCREEN_WIDTH/2-75, 150)];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kMAIN_SCREEN_WIDTH/2+75, topView.frame.size.height, kMAIN_SCREEN_WIDTH/2-75, 150)];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 85+150, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT-85-150)];
    
    UIColor *white = [UIColor whiteColor];
    topView.backgroundColor = white;
    leftView.backgroundColor = white;
    rightView.backgroundColor = white;
    bottomView.backgroundColor = white;
    
    [self addSubview:topView];
    [self addSubview:leftView];
    [self addSubview:rightView];
    [self addSubview:bottomView];
    
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMAIN_SCREEN_WIDTH/2-75, 85, 150, 150)];
    _headImg.layer.backgroundColor = [white CGColor];
//    _headImg.layer.borderWidth = 2;
//    _headImg.layer.borderColor = [[UIColor greenColor] CGColor];
    _headImg.layer.cornerRadius = 75;
    _headImg.alpha = 0.;
    [self addSubview:_headImg];
    
}

- (void) confirmHeadImg:(UIButton*)sender{
    
}

@end
