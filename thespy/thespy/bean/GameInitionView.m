//
//  GameInitionView.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameInitionView.h"

@implementation GameInitionView
@synthesize totalNum;
@synthesize citizenNum;
@synthesize whiteBoardNum;
@synthesize spyNum;

- (void)awakeFromNib{
    [_totalSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.totalLabel.text = @"8";        self.totalNum = 8;
    self.citizenLabel.text = @"7";      self.citizenNum = 7;
    self.spyLabel.text = @"1";          self.spyNum = 1;
    self.whiteboardLabel.text = @"0";   self.whiteBoardNum = 0;
    
    NSArray *allsubs = self.subviews;
    if (allsubs) {
        for (int i=0; i<[allsubs count]; i++) {
            id subview = [allsubs objectAtIndex:i];
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *b = subview;
                b.layer.borderColor = [[UIColor blueColor] CGColor];
                b.layer.borderWidth = .5;
                b.layer.cornerRadius = 3;
                [b setExclusiveTouch:YES];
            }
        }
    }
}

- (void) sliderValueChanged:(id)sender{
    UISlider *s = sender;
    self.totalNum = [[NSNumber numberWithFloat:s.value] intValue];
    self.totalLabel.text = [NSString stringWithFormat:@"%d", (int)self.totalNum];
    
    self.whiteboardLabel.text = @"0";
    self.whiteBoardNum = 0;
    
    self.spyLabel.text = @"1";
    self.spyNum = 1;
    
    self.citizenNum = self.totalNum - self.whiteBoardNum - self.spyNum;
    self.citizenLabel.text = [NSString stringWithFormat:@"%d", (int)self.citizenNum];
    
}

- (NSInteger) getMaxSpyCount:(NSInteger)total{
    return total * 8 / 20;
}

- (IBAction)whiteboardButtonClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 21) {
        if (self.whiteBoardNum>0) {
            self.whiteBoardNum -= 1;
            self.citizenNum += 1;
            
        }
    }else{
        if (self.whiteBoardNum<2) {
            self.whiteBoardNum += 1;
            self.citizenNum -= 1;
        }
    }
    self.whiteboardLabel.text = [NSString stringWithFormat:@"%d", (int)self.whiteBoardNum];
    self.citizenLabel.text = [NSString stringWithFormat:@"%d", (int)self.citizenNum];
}

- (IBAction)spyButtonClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 11) {
        if (self.spyNum>1) {
            self.spyNum -= 1;
            self.citizenNum += 1;
            
        }
    }else{
        if (self.spyNum<[self getMaxSpyCount:self.totalNum]) {
            self.spyNum += 1;
            self.citizenNum -= 1;
        }
    }
    self.spyLabel.text = [NSString stringWithFormat:@"%d", (int)self.spyNum];
    self.citizenLabel.text = [NSString stringWithFormat:@"%d", (int)self.citizenNum];
}


@end
