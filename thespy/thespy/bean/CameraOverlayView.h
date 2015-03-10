//
//  CameraOverlayView.h
//  thespy
//
//  Created by zhaoquan on 15/3/10.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SavePhotoDelegate <NSObject>

@optional
- (void) savePhoto;
- (void) cancelSave;
- (void) didBeginEditing:(UITextField *)textField;
- (void) didEndEditing:(UITextField *)textField;
@end

@interface CameraOverlayView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *deviceLable;
@property (strong, nonatomic) IBOutlet UITextField *nicknameField;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) id<SavePhotoDelegate> delegate;

@property (strong, nonatomic) NSString *nickName;

- (IBAction)cancel:(UIButton *)sender;
- (IBAction)confirm:(UIButton *)sender;
- (IBAction)cancelInput:(UITextField *)sender;

@end
