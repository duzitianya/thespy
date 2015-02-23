//
//  GamePlayingViewController.h
//  thespy
//
//  Created by zhaoquan on 15/2/12.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerBean.h"
#import "NetWorkingDelegate.h"
#import "GameRoomSubview.h"

@class GameRoomView;

@interface GamePlayingViewController : UIViewController<UIGestureRecognizerDelegate, UIAlertViewDelegate>
//@property (strong, nonatomic) GameRoomView *superGameView;

@property (strong, nonatomic) IBOutlet UIView *allPlayersView;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *citizenLabel;
@property (strong, nonatomic) IBOutlet UILabel *spyLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UILabel *roleLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIAlertView *alert;

@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) NSMutableArray *allPlayer;
@property (strong, nonatomic) PlayerBean *bean;
@property (assign, nonatomic) BOOL show;
@property (assign, nonatomic) BOOL isServer;
@property (assign, nonatomic) int killIndex;
@property (strong, nonatomic) NSArray *remoteData;
@property (assign, nonatomic) NSInteger index;//自己在服务列表中的位置
@property (strong, nonatomic) UITapGestureRecognizer *sender;
@property (assign, nonatomic) NSInteger spyNum;
@property (assign, nonatomic) NSInteger citizenNum;
@property (assign, nonatomic) NSInteger totalNum;
@property (assign, nonatomic) NSInteger whiteNum;

- (IBAction)toggle:(UIButton *)sender;
-(void)setUpFrame:(PlayerBean*)bean WithOthers:(NSMutableArray*)others WithGameInfo:(NSArray*)arr AsServer:(BOOL)asServer;

@end
