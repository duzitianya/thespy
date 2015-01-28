//
//  SettingsBoardView.h
//  thespy
//
//  Created by zhaoquan on 15/1/28.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PlayerBean.h"
#import "AppDelegate.h"
#import "SettingsView.h"

@protocol CameraOpenDelegate <NSObject>

@optional
- (void) presentViewController:(UIViewController*)view;
- (void) dismissViewController;

@end

@interface SettingsBoardView : UIView<UINavigationControllerDelegate, UIImagePickerControllerDelegate, SavePhotoDelegate>

@property (nonatomic, strong) UIImagePickerController *camera;

@property (nonatomic, weak) id<CameraOpenDelegate> delegate;

- (void) setupWithDelegate:(id<CameraOpenDelegate>)delegate;

@end
