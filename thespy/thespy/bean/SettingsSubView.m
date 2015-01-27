//
//  SettingsSubView.m
//  thespy
//
//  Created by zhaoquan on 15/1/27.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SettingsSubView.h"

@implementation SettingsSubView

- (void) awakeFromNib{
    NSString *deviceName = [UIDevice currentDevice].name;
    _deviceLabel.text = deviceName;
    
    _confirmButton.layer.borderWidth = 1;
    _confirmButton.layer.cornerRadius = 3;
    _confirmButton.layer.borderColor = [_confirmButton.titleLabel.textColor CGColor];
}

- (IBAction)saveData:(UIButton *)sender {
    NSLog(@"abcdefg=========");
}
@end
