//
//  SettingsView.h
//  thespy
//
//  Created by zhaoquan on 15/1/24.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "SettingsSubView.h"

@interface SettingsView : UIView<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIImageView *headImg;

@end
