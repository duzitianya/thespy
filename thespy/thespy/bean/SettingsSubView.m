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
    [_delegate savePhoto];
}

- (IBAction)cancel:(id)sender{
    if ([sender isKindOfClass:[UITextField class]]) {
        [sender resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _nickName = textField.text;
    return YES;
}

//最多15个字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text length] > 15){
        textField.text = [textField.text substringToIndex:15-1];
        return NO;
    }
    return YES; 
}
@end
