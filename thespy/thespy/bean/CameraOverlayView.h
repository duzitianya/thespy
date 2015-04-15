//
//  CameraOverlayView.h
//  thespy
//
//  Created by zhaoquan on 15/3/10.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivacyPolicyView.h"

@protocol SavePhotoDelegate <NSObject>

@optional
- (void) savePhoto;
- (void) cancelSave;
- (void) didBeginEditing:(UITextField *)textField;
- (void) didEndEditing:(UITextField *)textField;
@end

@interface CameraOverlayView : UIView<UITextFieldDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>
//@property (strong, nonatomic) IBOutlet UILabel *deviceLable;
@property (strong, nonatomic) IBOutlet UITextField *nicknameField;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UISwitch *declareSwitch;
@property (strong, nonatomic) IBOutlet UITextView *declareTextView;
@property (strong, nonatomic) PrivacyPolicyView *ppv;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) id<SavePhotoDelegate> delegate;

@property (strong, nonatomic) NSString *nickName;

- (IBAction)cancel:(UIButton *)sender;
- (IBAction)confirm:(UIButton *)sender;
- (IBAction)cancelInput:(UITextField *)sender;
- (IBAction)changeSwitchState:(UISwitch *)sender;

@end
