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
    [self.view addSubview:header];
    
    //游戏设置面板
    currentY += header.frame.size.height;
    self.mainGameView = [[[NSBundle mainBundle] loadNibNamed:@"GameInitionView" owner:self.view options:nil] lastObject];
    CGFloat plusY = [ActionView getViewHeight];
    self.mainGameView.frame = CGRectMake(0, currentY, width, height-barHeight-header.frame.size.height-plusY);
    self.mainGameView.contentSize = CGSizeMake(kMAIN_SCREEN_WIDTH, 388);
    self.mainGameView.scrollEnabled = YES;
    [self.mainGameView setShowsHorizontalScrollIndicator:NO];
    [self.mainGameView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.mainGameView];
    
    currentY += self.mainGameView.frame.size.height;
    
    //游戏控制按钮
    ActionView *actionView = [[ActionView alloc] init];
    [actionView setUpFrame:CGRectMake(0, currentY, width, height-barHeight-header.frame.size.height)];
    actionView.delegate = self;
    [self.view addSubview:actionView];
    
    
    //判断app是否未初始化过
    //如果尚未初始化，则进行初始化
    SPYFileUtil *util = [SPYFileUtil shareInstance];
    if ([util isUserDataExist]==NO) {
        //弹出初始化视图
        SettingsBoardView *sv = [[SettingsBoardView alloc]initWithFrame:CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT)];
        [sv setupWithDelegate:self];
        [self presentViewController:sv.camera];
    }
    
    //读取初始化数据
    NSString *name = [util getUserName];
    UIImage *headerData = [util getUserHeader];
    self.mainPlayer = [PlayerBean initWithData:headerData Name:name DeviceName:[UIDevice currentDevice].name];
    
    [header initWithPlayerBean:self.mainPlayer Delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) createServer{
    NSInteger totalNum = self.mainGameView.totalNum;
    NSInteger citizenNum = self.mainGameView.citizenNum;
    NSInteger whiteBoardNum = self.mainGameView.whiteBoardNum;
    NSInteger spyNum = totalNum - citizenNum - whiteBoardNum;
    
    GameRoomView *room = [[GameRoomView alloc] init];
    [room setupValues:totalNum SpyNum:spyNum CitizenNum:citizenNum WhiteboardNum:whiteBoardNum MainPlayer:self.mainPlayer];
    room.title = @"等待加入";
    [self.navigationController pushViewController:room animated:YES];
}

- (void) asClient{
    NSInteger totalNum = self.mainGameView.totalNum;
    NSInteger citizenNum = self.mainGameView.citizenNum;
    NSInteger whiteBoardNum = self.mainGameView.whiteBoardNum;
    NSInteger spyNum = totalNum - citizenNum - whiteBoardNum;
    
    PlayerListViewController *plvc = [[PlayerListViewController alloc] init:totalNum SpyNum:spyNum CitizenNum:citizenNum WhiteboardNum:whiteBoardNum];
    plvc.title = @"查找服务";
    [self.navigationController pushViewController:plvc animated:YES];
}

- (void) gotoHistoryList{
    HistoryListViewController *vc = [[HistoryListViewController alloc] init];
    vc.title = @"游戏记录";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) presentViewController:(UIViewController*)viewcontroller{
//    [self presentModalViewController:viewcontroller animated:YES];
    [self presentViewController:viewcontroller animated:YES completion:nil];
}

- (void) dismissViewController{
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
