//
//  PlayerHeader.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerHeader.h"

@implementation PlayerHeader

- (void)awakeFromNib{
    _headImg.layer.borderWidth = 1;
    _headImg.layer.borderColor = [[UIColor greenColor] CGColor];
//    masksToBounds防止子元素溢出父视图。
//    如果一个正方形要设置成圆形，代码为:
    _headImg.layer.cornerRadius = _headImg.frame.size.height/2;
    _headImg.layer.masksToBounds = YES;
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(15, 140, kMAIN_SCREEN_WIDTH-30, 0.5);
    lineLayer.contentsGravity = kCAGravityResizeAspect;
    [lineLayer setBackgroundColor:[UIColorFromRGB(0xdfe0df) CGColor]];
//    [self.layer addSublayer:lineLayer];
}

- (void) initWithPlayerBean:(PlayerBean *)bean Delegate:(id<HistoryDelegate>)delegate{
    NSURL *imageUrl = [NSURL URLWithString:bean.img];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    _headImg.image = image;
    _name.text = bean.name;
    _playerID.text = bean.id;
    [_historyButton addTarget:self action:@selector(historyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _delegate = delegate;
}

- (void) historyButtonClick:(id)sender{
    [self.delegate gotoHistoryList];
}

@end
