//
//  GameRoomCell.m
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameRoomCell.h"

@implementation GameRoomCell

- (void) setupWithData:(PlayerBean*)player{
    self.playerHeader.image = player.img;
    self.playerName.text = player.name;
}

- (void)awakeFromNib {
    
    self.layer.cornerRadius = 4;
    self.playerHeader.layer.cornerRadius = 4;
//    self.playerHeader.layer.cornerRadius = 35;
//    self.playerHeader.layer.masksToBounds = YES;
}

@end
