//
//  GamePlayingViewController.m
//  thespy
//
//  Created by zhaoquan on 15/2/12.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GamePlayingViewController.h"

@interface GamePlayingViewController ()

@end

@implementation GamePlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wordLabel.text = self.bean.word;
    self.show = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)toggle:(UIButton *)sender {
    [self.wordLabel setHidden:self.show];
    self.btn.titleLabel.text = self.show?@"显示词语":@"隐藏词语";
    self.show = !self.show;
}
@end
