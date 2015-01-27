//
//  SettingsSubView.h
//  thespy
//
//  Created by zhaoquan on 15/1/27.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsSubView : UIView
@property (strong, nonatomic) IBOutlet UILabel *deviceLabel;
@property (strong, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UISwitch *useNickName;
- (IBAction)saveData:(UIButton *)sender;

@end
