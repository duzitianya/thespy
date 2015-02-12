//
//  GamePlayingViewController.m
//  thespy
//
//  Created by zhaoquan on 15/2/12.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GamePlayingViewController.h"
#import "GameRoomCell.h"

@interface GamePlayingViewController ()

@end

@implementation GamePlayingViewController
@synthesize allPlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setUpFrame:(PlayerBean*)bean WithOthers:(NSMutableArray*)others{
    self.bean = bean;
    self.wordLabel.text = self.bean.word;
    self.show = YES;
    
    self.allPlayer = others;
    if (self.allPlayer&&[self.allPlayer count]>0) {
        for (int i=0; i<[self.allPlayer count]; i++) {
            GameRoomCell *gameRoomCell = [[[NSBundle mainBundle] loadNibNamed:@"GameRoomCell" owner:self options:nil] lastObject];
            [gameRoomCell setupWithData:[self.allPlayer objectAtIndex:i]];
            gameRoomCell.countLabel.text = [NSString stringWithFormat:@"%d", i];
            [self.allPlayersView addSubview:gameRoomCell];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)toggle:(UIButton *)sender {
    [self.wordLabel setHidden:self.show];
    self.btn.titleLabel.text = self.show?@"显示词语":@"隐藏词语";
    self.show = !self.show;
}
@end
