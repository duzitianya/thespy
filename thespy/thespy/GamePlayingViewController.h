//
//  GamePlayingViewController.h
//  thespy
//
//  Created by zhaoquan on 15/2/12.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerBean.h"

@interface GamePlayingViewController : UIViewController<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *allPlayersView;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *citizenLabel;
@property (strong, nonatomic) IBOutlet UILabel *spyLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;

@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) NSMutableArray *allPlayer;
@property (strong, nonatomic) PlayerBean *bean;
@property (assign, nonatomic) BOOL show;
@property (assign, nonatomic) BOOL isServer;

- (IBAction)toggle:(UIButton *)sender;
-(void)setUpFrame:(PlayerBean*)bean WithOthers:(NSMutableArray*)others WithArr:(NSArray*)arr AsServer:(BOOL)asServer;

@end
