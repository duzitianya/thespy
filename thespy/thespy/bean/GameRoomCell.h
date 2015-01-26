//
//  GameRoomCell.h
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface GameRoomCell : UIView
@property (strong, nonatomic) IBOutlet UIImageView *playerHeader;
@property (strong, nonatomic) IBOutlet UILabel *playerName;

- (void) setupWithData:(NSData*)headerData Name:(NSString*)name;

@end
