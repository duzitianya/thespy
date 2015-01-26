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
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, 20)];
    title.text = [NSString stringWithFormat:@"总人数:%d,平民:%d,卧底:%d,白板:%d", (int)_totalNum, (int)_citizenNum,(int) _spyNum, (int)_whiteBoardNum];
    title.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:title];
    currentY += 20;
    
    UILabel *nowPlayer = [[UILabel alloc]initWithFrame:CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, 20)];
    nowPlayer.text = [NSString stringWithFormat:@"目前参与人数:%d", (int)_totalNum];
    nowPlayer.backgroundColor = [UIColor blueColor];
    [self.view addSubview:nowPlayer];
    currentY += 20;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT)];
    [self.view addSubview:self.contentView];
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    [layout setItemSize:CGSizeMake(60, 80)];//设置cell的尺寸
//    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
//    layout.sectionInset = UIEdgeInsetsMake(15, 15, 20, 15);//设置其边界
//    GameRoomView *collection = [[GameRoomView alloc] initWithCollectionViewLayout:layout];
//    self.subRoomView = [[[NSBundle mainBundle] loadNibNamed:@"GameRoomSubview" owner:self options:nil] lastObject];
    PlayerListViewController *vc = [[PlayerListViewController alloc] init];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)setupValues:(NSInteger)totalNum SpyNum:(NSInteger)spyNum CitizenNum:(NSInteger)citizenNum WhiteboardNum:(NSInteger)whiteBoardNum{
    self.totalNum = totalNum;
    self.spyNum = spyNum;
    self.citizenNum = citizenNum;
    self.whiteBoardNum = whiteBoardNum;
    
    self.otherPlayer = [[NSMutableArray alloc] initWithCapacity:5];
}

@end
