//
//  GameRoomHeader.m
//  thespy
//
//  Created by zhaoquan on 15/1/30.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameRoomHeader.h"

@implementation GameRoomHeader

- (void)awakeFromNib{
    self.optionView.layer.cornerRadius = 5;
    self.playerNumView.layer.cornerRadius = 5;
}

@end
