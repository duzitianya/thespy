//
//  GameRoomView.h
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRoomCell.h"
#import "AppDelegate.h"
#import "PlayerBean.h"
#import "GameRoomSubview.h"

@interface GameRoomView : UIViewController
@property (nonatomic) NSInteger totalNum;       //参与者总数
@property (nonatomic) NSInteger spyNum;         //卧底数
@property (nonatomic) NSInteger citizenNum;     //平民数
@property (nonatomic) NSInteger whiteBoardNum;  //白板数

@property (nonatomic, strong) PlayerBean *selfBean;
@property (nonatomic, strong) NSMutableArray *otherPlayer;

@property (nonatomic, strong) GameRoomSubview *subRoomView;

- (void)setupValues:(NSInteger)totalNum SpyNum:(NSInteger)spyNum CitizenNum:(NSInteger)citizenNum WhiteboardNum:(NSInteger)whiteBoardNum;

@end
