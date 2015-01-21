//
//  GameInitionView.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height;

@interface GameInitionView : UIScrollView

@property (nonatomic) NSInteger totalNum;       //参与者总数
@property (nonatomic) NSInteger citizenNum;     //平民数
@property (nonatomic) NSInteger whiteBoardNum;  //白板数


@property (strong, nonatomic) IBOutlet UISlider *totalSlider;

@end
