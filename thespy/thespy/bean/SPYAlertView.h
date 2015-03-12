//
//  SPYAlertView.h
//  thespy
//
//  Created by zhaoquan on 15/3/12.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPYAlertView : UIView

@property (nonatomic, strong) UIAlertView *alert;

+(SPYAlertView *)shareInstance;

- (void)dismissAlertView;
- (void)createAlertView:(NSString*)title Message:(NSString*)message CancelTxt:(NSString*)cancelTxt OtherTxt:(NSString*)otherTxt Tag:(NSInteger)tag Delegate:(id<UIAlertViewDelegate>)delegate;

@end
