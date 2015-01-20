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
    
}

- (void) initWithPlayerBean:(PlayerBean *)bean{
//    _headImg = bean.img;
    _name.text = bean.name;
    _playerID.text = bean.id;
}

@end
