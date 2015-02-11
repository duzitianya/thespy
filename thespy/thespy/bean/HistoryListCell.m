//
//  HistoryListCellTableViewCell.m
//  thespy
//
//  Created by zhaoquan on 15/1/21.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "HistoryListCell.h"

@implementation HistoryListCell

- (void)awakeFromNib {
    
}

- (void) initWithGameResult:(GameResult*)result Index:(NSInteger)index{
    NSString *name = result._name;
    NSString *role = result._role;
    NSString *victory = result._victory;
    NSString *date = result._date;
    
    self.nameLabel.text = name;
    self.roleLabel.text = role;
    self.victoryLabel.text = victory;
    self.dateLabel.text = date;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", index+1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
