//
//  GamePlayingViewController.h
//  thespy
//
//  Created by zhaoquan on 15/2/12.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerBean.h"

@interface GamePlayingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *allPlayersView;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *citizenLabel;
@property (strong, nonatomic) IBOutlet UILabel *spyLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet UIButton *btn;

@property (strong, nonatomic) PlayerBean *bean;
@property (assign, nonatomic) BOOL show;

- (IBAction)toggle:(UIButton *)sender;

@end
