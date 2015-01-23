//
//  PlayerHeader.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerBean.h"
#import "AppDelegate.h"

@protocol TopViewDelegate <NSObject>

@optional

- (void) gotoHistoryList;
- (void) presentViewController:(UIViewController*)view;

@end

@interface PlayerHeader : UIView<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *playerID;
@property (strong, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) id<TopViewDelegate> delegate;
@property (strong, nonatomic) UIButton *changeButton;

- (void) initWithPlayerBean:(PlayerBean *)bean Delegate:(id<TopViewDelegate>)delegate;
- (void)changeHeadImg:(UIButton *)sender;

@end
