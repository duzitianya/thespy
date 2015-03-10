//
//  SettingsView.m
//  thespy
//
//  Created by zhaoquan on 15/1/24.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFrame];
    }
    return self;
}

- (void) setupFrame{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, 75)];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, kMAIN_SCREEN_WIDTH/2-75, 150)];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kMAIN_SCREEN_WIDTH/2+75, topView.frame.size.height, kMAIN_SCREEN_WIDTH/2-75, 150)];
    
    topView.alpha = 0.7;
    leftView.alpha = 0.7;
    rightView.alpha = 0.7;
    
    UIColor *col = UIColorFromRGB(0x64FFFF);
    topView.backgroundColor = col;
    leftView.backgroundColor = col;
    rightView.backgroundColor = col;
    
    NSString *t = @"游戏设置";
    CGSize titleSize = [t sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kMAIN_SCREEN_WIDTH/2, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat width = topView.frame.size.width;
    CGFloat height = topView.frame.size.height;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(width/2-titleSize.width/2, height/2-titleSize.height/2, titleSize.width, titleSize.height)];
    [title setFont:[UIFont systemFontOfSize:16]];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.text = t;
    [topView addSubview:title];
    
    [self addSubview:topView];
    [self addSubview:leftView];
    [self addSubview:rightView];
    
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMAIN_SCREEN_WIDTH/2-75, 75, 150, 150)];
    _headImg.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _headImg.alpha = 0.;
    [self addSubview:_headImg];
    
    _subview = [[[NSBundle mainBundle] loadNibNamed:@"SettingsSubView" owner:self options:nil] lastObject];
    _subview.frame = CGRectMake(0, 75+150, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT-75-150);
    [self addSubview:_subview];
}

- (void) addSavePhotoDelegate:(id<SavePhotoDelegate>)delegate{
    _subview.delegate = delegate;
}

- (void) confirmHeadImg:(UIButton*)sender{
    
}


@end
