//
//  PlayerInfoViewController.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerInfoViewController.h"

@interface PlayerInfoViewController ()

@end

@implementation PlayerInfoViewController
@synthesize mainPlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = kMAIN_SCREEN_WIDTH;
    CGFloat height = kMAIN_SCREEN_HEIGHT;
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height+20;
    
    CGFloat currentY = barHeight;
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"PlayerHeader" owner:self.view options:nil] lastObject];
    self.header.frame = CGRectMake(0, currentY, width, self.header.frame.size.height);
    [self.header initWithPlayerBean:self.mainPlayer Delegate:self];
    [self.view addSubview:self.header];
    
    currentY += self.header.frame.size.height;
    GameInitionView *gameView = [[[NSBundle mainBundle] loadNibNamed:@"GameInitionView" owner:self.view options:nil] lastObject];
    gameView.frame = CGRectMake(0, currentY, width, gameView.frame.size.height);
    [self.view addSubview:gameView];
    
    currentY += gameView.frame.size.height;
    
    ActionView *actionView = [[ActionView alloc] init];
    [actionView setUpFrame:CGRectMake(0, currentY, width, height-barHeight-self.header.frame.size.height)];
    actionView.delegate = self;
    [self.view addSubview:actionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) createServer{
    NSLog(@"create server. . . ");
}

- (void) asClient{
    NSLog(@"as client. . . ");
}

- (void) gotoHistoryList{
    HistoryListViewController *vc = [[HistoryListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
