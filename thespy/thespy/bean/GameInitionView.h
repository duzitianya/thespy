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
@property (nonatomic) NSInteger spyNum;         //卧底数

@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *citizenLabel;
@property (strong, nonatomic) IBOutlet UILabel *spyLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteboardLabel;

@property (strong, nonatomic) IBOutlet UISlider *totalSlider;

@property (strong, nonatomic) IBOutlet UIButton *spyAdd;
@property (strong, nonatomic) IBOutlet UIButton *spyRemove;
@property (strong, nonatomic) IBOutlet UIButton *whiteboardAdd;
@property (strong, nonatomic) IBOutlet UIButton *whiteboardRemove;
- (IBAction)whiteboardButtonClick:(UIButton *)sender;
- (IBAction)spyButtonClick:(UIButton *)sender;

@end
