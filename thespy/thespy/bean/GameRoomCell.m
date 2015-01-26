//
//  GameRoomCell.m
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameRoomCell.h"

@implementation GameRoomCell

- (void) setupWithData:(NSData*)headerData Name:(NSString*)name{
    self.playerHeader.image = [[UIImage alloc] initWithData:headerData];
    self.playerName.text = [UIDevice currentDevice].name;
}

- (void)awakeFromNib {
    
    self.layer.cornerRadius = 4;
    self.playerHeader.layer.cornerRadius = 4;
}

@end
