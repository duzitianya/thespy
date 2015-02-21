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
    UIImage *header = player.img;
    if (header){
        self.playerHeader.image = header;
    }
    NSString *name = player.name;
    if (name) {
        self.playerName.text = name;
    }else{
        name = player.deviceName;
        if (name) {
            self.playerName.text = name;
        }
    }
}

- (void)awakeFromNib {
    
    self.layer.cornerRadius = 4;
    self.playerHeader.layer.cornerRadius = 4;
    self.playerHeader.layer.masksToBounds = YES;
    
    self.countLabel.layer.cornerRadius = 10;
    self.countLabel.layer.masksToBounds = YES;
    
    self.roleLabel.layer.borderWidth = 2;
    self.roleLabel.layer.borderColor = [[UIColor redColor]CGColor];
    self.roleLabel.transform = CGAffineTransformMakeRotation(M_1_PI*-1);
    [self.roleLabel setHidden:YES];
}

@end
