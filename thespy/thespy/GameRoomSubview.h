//
//  GameRoomSubview.h
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRoomCell.h"

@interface GameRoomSubview : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *allPlayer;

- (void) setMainPlayer:(PlayerBean*)player;

@end
