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
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, 20)];
    title.text = [NSString stringWithFormat:@"总人数:%d,平民:%d,卧底:%d,白板:%d", (int)_totalNum, (int)_citizenNum,(int) _spyNum, (int)_whiteBoardNum];
    title.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:title];
    
    UILabel *nowPlayer = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kMAIN_SCREEN_WIDTH, 20)];
    nowPlayer.text = [NSString stringWithFormat:@"目前参与人数:%d", (int)_totalNum];
    nowPlayer.backgroundColor = [UIColor blueColor];
    [self.view addSubview:nowPlayer];
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    [layout setItemSize:CGSizeMake(60, 80)];//设置cell的尺寸
//    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
//    layout.sectionInset = UIEdgeInsetsMake(15, 15, 20, 15);//设置其边界
//    GameRoomView *collection = [[GameRoomView alloc] initWithCollectionViewLayout:layout];
    self.subRoomView = [[[NSBundle mainBundle] loadNibNamed:@"GameRoomSubview" owner:self options:nil] lastObject];

    [self addChildViewController:subRoomView];
}

- (void)setupValues:(NSInteger)totalNum SpyNum:(NSInteger)spyNum CitizenNum:(NSInteger)citizenNum WhiteboardNum:(NSInteger)whiteBoardNum{
    self.totalNum = totalNum;
    self.spyNum = spyNum;
    self.citizenNum = citizenNum;
    self.whiteBoardNum = whiteBoardNum;
    
    self.otherPlayer = [[NSMutableArray alloc] initWithCapacity:5];
}

@end
