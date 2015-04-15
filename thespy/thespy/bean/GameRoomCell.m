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
//        name = player.deviceName;
        if (name) {
            self.playerName.text = name;
        }
    }
    
    self.status = player.status;
    switch (self.status) {
        case BLE_ONLINE:{//在线
            self.statusLable.backgroundColor = [UIColor greenColor];
            self.statusLable.text = @"就绪";
            break;
        }
        case BLE_OFFLINE:{//离线
            self.statusLable.backgroundColor = [UIColor grayColor];
            self.statusLable.text = @"离线";
            break;
        }
        case BLE_CONNECTTING:{//正在链接
            self.statusLable.backgroundColor = [UIColor yellowColor];
            self.statusLable.text = @"等待";
            break;
        }
        case BLE_HIDDEN:{//隐藏
            self.statusLable.hidden = YES;
            break;
        }
        default:
            
            break;
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
    
    self.statusLable.layer.cornerRadius = 4;
    self.statusLable.layer.masksToBounds = YES;
    [self.statusLable setHidden:YES];
}

@end
