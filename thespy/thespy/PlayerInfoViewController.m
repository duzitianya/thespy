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

@implementation PlayerInfoViewController{
    PlayerHeader *header;
}
@synthesize mainPlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = kMAIN_SCREEN_WIDTH;
    CGFloat height = kMAIN_SCREEN_HEIGHT;
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height+20;
    
    //主界面头部
    CGFloat currentY = barHeight;
    header = [[[NSBundle mainBundle] loadNibNamed:@"PlayerHeader" owner:self.view options:nil] lastObject];
    header.frame = CGRectMake(0, currentY, width, header.frame.size.height);
    [header initWithPlayerBean:self.mainPlayer Delegate:self];
    [self.view addSubview:header];
    
    //游戏设置面板
    currentY += header.frame.size.height;
    self.mainGameView = [[[NSBundle mainBundle] loadNibNamed:@"GameInitionView" owner:self.view options:nil] lastObject];
    CGFloat plusY = [ActionView getViewHeight];
    self.mainGameView.frame = CGRectMake(0, currentY, width, height-barHeight-header.frame.size.height-plusY);
    [self.view addSubview:self.mainGameView];
    
    currentY += self.mainGameView.frame.size.height;
    
    //游戏控制按钮
    ActionView *actionView = [[ActionView alloc] init];
    [actionView setUpFrame:CGRectMake(0, currentY, width, height-barHeight-header.frame.size.height)];
    actionView.delegate = self;
    [self.view addSubview:actionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) createServer{
    NSLog(@"create server. . . ");
    NSInteger totalNum = self.mainGameView.totalNum;
    NSInteger citizenNum = self.mainGameView.citizenNum;
    NSInteger whiteBoardNum = self.mainGameView.whiteBoardNum;
    NSInteger spyNum = totalNum - citizenNum - whiteBoardNum;
    
    self.mainPlayer.img = header.headImg.image;
    
    GameRoomView *room = [[GameRoomView alloc] init];
    [room setupValues:totalNum SpyNum:spyNum CitizenNum:citizenNum WhiteboardNum:whiteBoardNum MainPlayer:self.mainPlayer];
    room.title = @"等待加入";
    [self.navigationController pushViewController:room animated:YES];
}

- (void) asClient{
    NSLog(@"as client. . . ");
    NSInteger totalNum = self.mainGameView.totalNum;
    NSInteger citizenNum = self.mainGameView.citizenNum;
    NSInteger whiteBoardNum = self.mainGameView.whiteBoardNum;
    NSInteger spyNum = totalNum - citizenNum - whiteBoardNum;
    
    PlayerListViewController *plvc = [[PlayerListViewController alloc] init:totalNum SpyNum:spyNum CitizenNum:citizenNum WhiteboardNum:whiteBoardNum];
    plvc.isServer = NO;
    plvc.title = @"查找服务";
    [self.navigationController pushViewController:plvc animated:YES];
}

- (void) gotoHistoryList{
    HistoryListViewController *vc = [[HistoryListViewController alloc] init];
    vc.title = @"游戏记录";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) presentViewController:(UIViewController*)viewcontroller{
    [self presentModalViewController:viewcontroller animated:YES];
}

- (void) dismissViewController{
    [self dismissModalViewControllerAnimated:YES];
}

@end
