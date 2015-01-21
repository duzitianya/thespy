//
//  GameInitionView.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameInitionView.h"

@implementation GameInitionView
@synthesize totalNum;
@synthesize citizenNum;
@synthesize whiteBoardNum;

- (instancetype)init{
    self = [super init];
    if (self) {
        [_totalSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void) sliderValueChanged:(id)sender{
    UISlider *s = sender;
    self.totalNum = [[NSNumber numberWithFloat:s.value] intValue];
}

@end
