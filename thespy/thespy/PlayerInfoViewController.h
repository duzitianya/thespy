//
//  PlayerInfoViewController.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PlayerBean.h"
#import "PlayerHeader.h"
#import "ActionView.h"
#import "GameInitionView.h"
#import "HistoryListViewController.h"
#import "GameRoomView.h"
#import "SPYFileUtil.h"
#import "SettingsBoardView.h"

@interface PlayerInfoViewController : UIViewController<ActionViewDelegate, CameraOpenDelegate, TopViewDelegate>

@property (nonatomic, strong) PlayerBean *mainPlayer;

@property (nonatomic, strong) GameInitionView *mainGameView;

@property (nonatomic) NSInteger totalNum;       //参与者总数
@property (nonatomic) NSInteger citizenNum;     //平民数
@property (nonatomic) NSInteger whiteBoardNum;  //白板数

@end
