//
//  CameraOverlayView.m
//  thespy
//
//  Created by zhaoquan on 15/3/10.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "CameraOverlayView.h"
#import "SPYFileUtil.h"
#import "SPYAlertView.h"
#import "UIImage+category.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraOverlayView

- (void) awakeFromNib{
//    NSString *deviceName = [UIDevice currentDevice].name;
//    _deviceLable.text = deviceName;
    
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
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:self.declareTextView.text];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    self.declareTextView.attributedText = content;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPrivacyPolicyView)];
    tap.numberOfTouchesRequired = 1;//双击
    tap.numberOfTapsRequired = 1;//一个手指点击
    tap.delegate = self;
    [self.declareTextView addGestureRecognizer:tap];
    
    self.ppv = [[[NSBundle mainBundle]loadNibNamed:@"PrivacyPolicyView" owner:self options:nil]lastObject];
    [self.ppv setHidden:YES];
    self.ppv.frame = CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT);
    [self addSubview:self.ppv];
    
    //如果是初始化设置，则不显示取消按钮
    SPYFileUtil *util = [SPYFileUtil shareInstance];
    if ([util isUserDataExist]==NO) {
        [self.cancelButton setHidden:YES];
    }
    
    [self viewDidAppear];
}

- (void)showPrivacyPolicyView{
    [self.ppv setHidden:NO];
}

- (void)viewDidAppear{
    //如果禁止相机，则显示默认图片
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        self.photoView.alpha = 1;
        UIImage *img = [[SPYFileUtil shareInstance]getUserHeader];
        img = [img thumbnailWithImageWithoutScale:img size:CGSizeMake(150, 150)];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        [self.photoView addSubview:imgView];
        
//        [[SPYAlertView shareInstance]createAlertView:@"拜托让我可以调用相机吧！" Message:@"" CancelTxt:@"知道了" OtherTxt:nil Tag:0 Delegate:self];
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

- (IBAction)changeSwitchState:(UISwitch *)sender {
    if(sender.on==NO){
        [self.cancelButton setHidden:YES];
    }else{
        SPYFileUtil *util = [SPYFileUtil shareInstance];
        if ([util isUserDataExist]==YES) {
            [self.cancelButton setHidden:NO];
        }
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
