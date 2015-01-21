//
//  PlayerInfoViewController.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerBean.h"
#import "PlayerListViewController.h"
#import "PlayerHeader.h"
#import "ActionView.h"
#import "GameInitionView.h"
#import "HistoryListViewController.h"

@interface PlayerInfoViewController : UIViewController<ActionViewDelegate, HistoryDelegate>

@property (nonatomic, strong) PlayerBean *mainPlayer;
@property (nonatomic, strong) PlayerHeader *header;
@property (nonatomic, strong) GameInitionView *mainGameView;

@property (nonatomic) NSInteger totalNum;       //参与者总数
@property (nonatomic) NSInteger citizenNum;     //平民数
@property (nonatomic) NSInteger whiteBoardNum;  //白板数

@end
