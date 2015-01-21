//
//  PlayerInfoViewController.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerBean.h"
#import "PlayerListViewController.h"
#import "PlayerHeader.h"
#import "ActionView.h"

@interface PlayerInfoViewController : UIViewController<ActionViewDelegate>

@property (nonatomic, strong) PlayerBean *mainPlayer;
@property (nonatomic, strong) PlayerHeader *header;

@end
