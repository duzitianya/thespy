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

-(void)viewDidAppear:(BOOL)animated{
    self.wordLabel.text = self.bean.word;
    self.show = YES;
    
    if (self.dataArr) {
        self.totalLabel.text = self.dataArr[0];
        self.citizenLabel.text = self.dataArr[1];
        self.spyLabel.text = self.dataArr[2];
        self.whiteLabel.text = self.dataArr[3];
    }
    
    if (self.allPlayer&&[self.allPlayer count]>0) {
        NSInteger height = 39;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(killPlayer:)];
        singleTap.delegate = self;
        for (int i=0; i<[self.allPlayer count]; i++) {
            GameRoomCell *gameRoomCell = [[[NSBundle mainBundle] loadNibNamed:@"GameRoomCell" owner:self options:nil] lastObject];
            gameRoomCell.frame = CGRectMake(10, height, gameRoomCell.frame.size.width, gameRoomCell.frame.size.height);
            [gameRoomCell setupWithData:[self.allPlayer objectAtIndex:i]];
            gameRoomCell.countLabel.text = [NSString stringWithFormat:@"%d", (i+1)];
            [self.allPlayersView addSubview:gameRoomCell];
            [gameRoomCell addGestureRecognizer:singleTap];
            
            height += gameRoomCell.frame.size.height + 10;
        }
    }
    
    self.allPlayersView.layer.cornerRadius = 3;
    self.allPlayersView.layer.borderWidth = 1;
    self.allPlayersView.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    if (!self.isServer) {
        [self.tipsLabel setHidden:YES];
    }
}

-(void)setUpFrame:(PlayerBean*)bean WithOthers:(NSMutableArray*)others WithArr:(NSArray*)arr AsServer:(BOOL)asServer{
    self.bean = bean;
    self.allPlayer = others;
    self.dataArr = arr;
    self.isServer = asServer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)toggle:(UIButton *)sender {
    [self.wordLabel setHidden:self.show];
    NSString *text = !self.show?@"显示词语":@"隐藏词语";
    [self.btn.titleLabel setText:@"abc"];
    self.show = !self.show;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)killPlayer:(UITapGestureRecognizer *)sender{
    NSUInteger touchTimes = sender.numberOfTouches;
    if (touchTimes>=2) {
        NSLog(@"press--->");
    }
}
@end
