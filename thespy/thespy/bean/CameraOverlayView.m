//
//  CameraOverlayView.m
//  thespy
//
//  Created by zhaoquan on 15/3/10.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "CameraOverlayView.h"
#import "SPYFileUtil.h"

@implementation CameraOverlayView

- (void) awakeFromNib{
    NSString *deviceName = [UIDevice currentDevice].name;
    _deviceLable.text = deviceName;
    
    _confirmButton.layer.borderWidth = 1;
    _confirmButton.layer.cornerRadius = 3;
    _confirmButton.layer.borderColor = [_confirmButton.titleLabel.textColor CGColor];
    
    NSString *name = [[SPYFileUtil shareInstance]getUserName];//用户名
    if (name!=nil&&[name length]>0) {
        _nicknameField.text = name;
    }
    _nicknameField.delegate = self;
    
    NSString *uname = [[SPYFileUtil shareInstance]getUserName];
    if (uname!=nil&&[uname length]>0) {
        _nickName = uname;
    }
}

- (IBAction)cancel:(id)sender {
    [_delegate cancelSave];
}

- (IBAction)confirm:(UIButton *)sender {
    [_delegate savePhoto];
}

- (IBAction)cancelInput:(UITextField *)sender {
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
    if ([textField.text length] > 10){
        textField.text = [textField.text substringToIndex:10-1];
        return NO;
    }
    return YES;
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_delegate didBeginEditing:textField];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_delegate didEndEditing:textField];
}

@end
