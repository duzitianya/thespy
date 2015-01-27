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
    NSArray *all = [self subviews];
    for (int i=0; i<[all count]; i++) {
        UIView *v = all[i];
        NSLog(@"class:%@--->x:%f--y:%f,  width:%f--height:%f", [[v class] description], v.frame.origin.x, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
        NSArray *subs = [v subviews];
        for (int j=0; j<[subs count]; j++) {
            UIView *subv = subs[j];
            NSLog(@"class:%@--->x:%f--y:%f,  width:%f--height:%f", [[subv class] description], subv.frame.origin.x, subv.frame.origin.y, subv.frame.size.width, subv.frame.size.height);
        }
    }
}

- (instancetype) init{
    self = [super init];
    if (self) {
        [self setupFrame];
    }
    return self;
}

- (void) setupFrame{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, 75)];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, kMAIN_SCREEN_WIDTH/2-75, 150)];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kMAIN_SCREEN_WIDTH/2+75, topView.frame.size.height, kMAIN_SCREEN_WIDTH/2-75, 150)];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 75+150, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT-75-150)];
    
    UIColor *col = UIColorFromRGB(0x64FFFF);
    topView.backgroundColor = col;
    leftView.backgroundColor = col;
    rightView.backgroundColor = col;
    bottomView.backgroundColor = col;
    
    NSString *t = @"游戏设置";
    CGSize titleSize = [t sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kMAIN_SCREEN_WIDTH/2, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat width = topView.frame.size.width;
    CGFloat height = topView.frame.size.height;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(width/2-titleSize.width/2, height/2-titleSize.height/2, titleSize.width, titleSize.height)];
    [title setFont:[UIFont systemFontOfSize:16]];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.text = t;
    [topView addSubview:title];
    
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMAIN_SCREEN_WIDTH/2-75, 75, 150, 150)];
    _headImg.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _headImg.alpha = 0.;
    [self addSubview:_headImg];
    
    SettingsSubView *subview = [[[NSBundle mainBundle] loadNibNamed:@"SettingsSubView" owner:self options:nil] lastObject];
    [bottomView addSubview:subview];
    
    [self addSubview:topView];
    [self addSubview:leftView];
    [self addSubview:rightView];
    [self addSubview:bottomView];
}

- (void) confirmHeadImg:(UIButton*)sender{
    
}

@end
