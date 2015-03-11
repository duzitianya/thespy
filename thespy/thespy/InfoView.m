//
//  InfoView.m
//  thespy
//
//  Created by zhaoquan on 15/3/11.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "InfoView.h"

@implementation InfoView

- (void)awakeFromNib{
    self.msgView.layer.cornerRadius = 8;
    [self.vertical setConstant:self.vertical.constant - (self.button.frame.size.height/2)];
    [self.leading setConstant:self.leading.constant + (self.button.frame.size.height/2)];
}

- (IBAction)close:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeappinfo" object:nil];
}
@end
