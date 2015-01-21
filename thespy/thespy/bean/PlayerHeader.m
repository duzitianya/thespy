//
//  PlayerHeader.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerHeader.h"

@implementation PlayerHeader

- (void)awakeFromNib{
    _headImg.layer.cornerRadius = 40.;
}

- (void) initWithPlayerBean:(PlayerBean *)bean{
    _headImg.image = [UIImage imageNamed:bean.img];
    _name.text = bean.name;
    _playerID.text = bean.id;
}

@end
