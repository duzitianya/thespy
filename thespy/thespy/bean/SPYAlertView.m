//
//  SPYAlertView.m
//  thespy
//
//  Created by zhaoquan on 15/3/12.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SPYAlertView.h"

@implementation SPYAlertView

+(SPYAlertView *)shareInstance{
    static dispatch_once_t pred;
    static SPYAlertView *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SPYAlertView alloc] init];
    });
    return shared;
}

- (void)dismissAlertView{
    if (self.alert) {
        [self.alert dismissWithClickedButtonIndex:0 animated:NO];
    }
}

- (void)createAlertView:(NSString*)title Message:(NSString*)message CancelTxt:(NSString*)cancelTxt OtherTxt:(NSString*)otherTxt Tag:(NSInteger)tag Delegate:(id<UIAlertViewDelegate>)delegate{
    [self dismissAlertView];
    self.alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTxt otherButtonTitles:otherTxt, nil];
    self.alert.delegate = delegate;
    [self.alert setTag:tag];
    [self.alert show];
}

@end
