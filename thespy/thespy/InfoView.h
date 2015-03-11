//
//  InfoView.h
//  thespy
//
//  Created by zhaoquan on 15/3/11.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIView
@property (strong, nonatomic) IBOutlet UIView *msgView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vertical;

- (IBAction)close:(UIButton *)sender;
@end
