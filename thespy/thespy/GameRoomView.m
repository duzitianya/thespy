//
//  GameRoomView.m
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameRoomView.h"

@implementation GameRoomView
@synthesize subRoomView;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat currentY = barHeight + 20;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, 30)];
    title.text = [NSString stringWithFormat:@"总人数:%d,平民:%d,卧底:%d,白板:%d", (int)_totalNum, (int)_citizenNum,(int) _spyNum, (int)_whiteBoardNum];
    title.backgroundColor = [UIColor darkGrayColor];
    title.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:title];
    currentY += 30;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, 5)];
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    currentY += 5;
    
    UILabel *nowPlayer = [[UILabel alloc]initWithFrame:CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, 30)];
    nowPlayer.text = [NSString stringWithFormat:@"目前参与人数:%d", (int)_totalNum];
    nowPlayer.backgroundColor = [UIColor darkGrayColor];
    nowPlayer.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:nowPlayer];
    currentY += 30;
    
    GameRoomSubview *subview = [[GameRoomSubview alloc] initWithNibName:@"GameRoomSubview" bundle:[NSBundle mainBundle]];
    subview.view.frame = CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT);
    [subview setMainPlayer:self.mainPlayer];
    [self addChildViewController:subview];
    [self.view addSubview:subview.view];
    
    self.server = [SPYService shareInstance];
    self.server.delegate = self;
    if (!self.server.isServerOpen) {
        [self.server publishServer];
    }
}

- (void) reloadClientListTable{
    [self.subRoomView.collectionView reloadData];
}

- (void)setupValues:(NSInteger)totalNum SpyNum:(NSInteger)spyNum CitizenNum:(NSInteger)citizenNum WhiteboardNum:(NSInteger)whiteBoardNum MainPlayer:(PlayerBean *)mainPlayer{
    self.totalNum = totalNum;
    self.spyNum = spyNum;
    self.citizenNum = citizenNum;
    self.whiteBoardNum = whiteBoardNum;
    self.mainPlayer = mainPlayer;
    
    self.otherPlayer = [[NSMutableArray alloc] initWithCapacity:5];
}

@end
