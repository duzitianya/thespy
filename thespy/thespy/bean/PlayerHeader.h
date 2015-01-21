//
//  PlayerHeader.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerBean.h"

@interface PlayerHeader : UIView
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *playerID;
@property (strong, nonatomic) IBOutlet UIButton *history;

- (void) initWithPlayerBean:(PlayerBean *)bean;

@end
