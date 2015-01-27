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
}

- (IBAction)saveData:(UIButton *)sender {
    NSLog(@"abcdefg=========");
}
@end
