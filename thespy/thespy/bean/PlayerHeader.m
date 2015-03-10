//
//  PlayerHeader.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerHeader.h"

@implementation PlayerHeader{
    NSDictionary *imgInfo;
}

- (void)awakeFromNib{
    _headImg.layer.borderWidth = 1;
    _headImg.layer.borderColor = [[UIColor greenColor] CGColor];
//    masksToBounds防止子元素溢出父视图。
//    如果一个正方形要设置成圆形，代码为:
    _headImg.layer.cornerRadius = _headImg.frame.size.height/2;
    _headImg.layer.masksToBounds = YES;
    
    CGFloat height = _headImg.frame.size.height;
    CGFloat width = _headImg.frame.size.width;
    CGFloat x = _headImg.frame.origin.x;
    CGFloat y = _headImg.frame.origin.y;
    self.changeButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.changeButton addTarget:self action:@selector(changeHeadImg:) forControlEvents:UIControlEventTouchUpInside];
    self.changeButton.layer.cornerRadius = _headImg.layer.cornerRadius;
    [self.changeButton setAlpha:0.1];
    [self insertSubview:self.changeButton aboveSubview:_headImg];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(15, self.frame.size.height, kMAIN_SCREEN_WIDTH-30, 1);
    lineLayer.contentsGravity = kCAGravityResizeAspect;
    [lineLayer setBackgroundColor:[UIColorFromRGB(0xdfe0df) CGColor]];
    [self.layer addSublayer:lineLayer];
}

- (void) initWithPlayerBean:(PlayerBean *)bean Delegate:(id<TopViewDelegate,CameraOpenDelegate>)delegate{
    _nickName.text = bean.name;
    _deviceName.text = bean.deviceName;
    _headImg.image = bean.img;
    [_historyButton addTarget:self action:@selector(historyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _delegate = delegate;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeaderData) name:@"reloadHeaderData" object:nil];
}

- (void)changeHeadImg:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==NO) {
        return;
    }else{
        SettingsBoardView *sv = [[SettingsBoardView alloc]initWithFrame:CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT)];
        [sv setupWithDelegate:_delegate];
        [_delegate presentViewController:sv.camera];
    }
}

- (void) historyButtonClick:(id)sender{
    [self.delegate gotoHistoryList];
}

- (void) reloadHeaderData{
    SPYFileUtil *util = [SPYFileUtil shareInstance];
    NSString *name = [util getUserName];
    UIImage *headerData = [util getUserHeader];
    
    _nickName.text = name;
    _headImg.image = headerData;
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

@end
