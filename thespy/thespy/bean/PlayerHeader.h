//
//  PlayerHeader.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PlayerBean.h"
#import "AppDelegate.h"
#import "SettingsBoardView.h"

@protocol TopViewDelegate <NSObject>

@optional

- (void) gotoHistoryList;

@end

@interface PlayerHeader : UIView

@property (strong, nonatomic) IBOutlet UIImageView *headImg;
//@property (strong, nonatomic) IBOutlet UILabel *deviceName;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) id<TopViewDelegate,CameraOpenDelegate> delegate;
@property (strong, nonatomic) UIButton *changeButton;

- (void) initWithPlayerBean:(PlayerBean *)bean Delegate:(id<TopViewDelegate,CameraOpenDelegate>)delegate;
- (void)changeHeadImg:(UIButton *)sender;

@end
