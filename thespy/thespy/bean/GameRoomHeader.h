//
//  GameRoomHeader.h
//  thespy
//
//  Created by zhaoquan on 15/1/30.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameRoomHeader : UIView
@property (strong, nonatomic) IBOutlet UILabel *citizenLabel;
@property (strong, nonatomic) IBOutlet UILabel *spyLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteboardLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentLabel;
@property (strong, nonatomic) IBOutlet UIView *optionView;
@property (strong, nonatomic) IBOutlet UIView *playerNumView;

@end
