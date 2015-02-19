//
//  GamePlayingViewController.m
//  thespy
//
//  Created by zhaoquan on 15/2/12.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GamePlayingViewController.h"
#import "GameRoomCell.h"
#import "SPYConnection.h"
#import "SPYConnection+Delegate.h"
#import "GameRoomView.h"


@interface GamePlayingViewController ()

@end

@implementation GamePlayingViewController
@synthesize allPlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(killPlayer:)];
    self.doubleTap.numberOfTouchesRequired = 1;//双击
    self.doubleTap.numberOfTapsRequired = 1;//一个手指点击
    self.doubleTap.delegate = self;
    
    self.remoteData = [[NSArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(killPlayerRemote:) name:@"killPlayer" object:nil];
}

-(void)killPlayerRemote:(NSNotification*) notification{
    NSArray *arr = (NSArray*)[notification object];
    NSInteger index = [(NSNumber*)arr[0] integerValue];
    PlayerRole role = [(NSNumber*)arr[1] intValue];
    NSLog(@"index--->%d, role--->%ld", (int)index, role);
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
        for (int i=0; i<[self.allPlayer count]; i++) {
            GameRoomCell *gameRoomCell = [[[NSBundle mainBundle] loadNibNamed:@"GameRoomCell" owner:self options:nil] lastObject];
            gameRoomCell.frame = CGRectMake(10, height, gameRoomCell.frame.size.width, gameRoomCell.frame.size.height);
            [gameRoomCell setupWithData:[self.allPlayer objectAtIndex:i]];
            gameRoomCell.countLabel.text = [NSString stringWithFormat:@"%d", (i+1)];
            if (self.isServer) {
                [gameRoomCell addGestureRecognizer:self.doubleTap];
            }
            
            [self.allPlayersView addSubview:gameRoomCell];
            height += gameRoomCell.frame.size.height + 10;
        }
    }
    
    self.allPlayersView.layer.cornerRadius = 4;
    self.allPlayersView.layer.borderWidth = 1;
    self.allPlayersView.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    if (!self.isServer) {
        [self.tipsLabel setHidden:YES];
    }
    
    self.btn.layer.borderWidth = 1;
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.borderColor = [self.btn.titleLabel.textColor CGColor];
}

-(void)setUpFrame:(PlayerBean*)bean WithOthers:(NSMutableArray*)others WithGameInfo:(NSArray*)arr AsServer:(BOOL)asServer{
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
    NSString *text = self.show?@"显示词语":@"隐藏词语";
    [self.btn setTitle:text forState:UIControlStateNormal];
    [self.btn updateConstraintsIfNeeded];
    self.show = !self.show;
}

-(void)killPlayer:(UITapGestureRecognizer *)sender{
    GameRoomCell *room = (GameRoomCell*)[sender view];
    NSString *name = room.playerName.text;
    NSString *title = [NSString stringWithFormat:@"确认投票给 %@ 吗？", name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"再想想", nil];
    alert.delegate = self;
    [alert show];
    if ([room.countLabel.text intValue]>=1) {
        self.killIndex = [room.countLabel.text intValue] - 1;
    }else{
        self.killIndex = 0;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"kill index is--->%d", self.killIndex);
        //给被杀掉客户端发送被杀数据
        if ([self.allPlayer count]>0) {
            int i=0;
            if (self.killIndex==0) {//self.killIndex==0说明被杀的是主机，不需要给自己发送数据，只需要给其余客户端发送数据即可
                i = 1;
            }
            
            PlayerBean *bean = [self.allPlayer objectAtIndex:self.killIndex];
            NSNumber *indexSelected = [[NSNumber alloc]initWithInt:self.killIndex];
            NSNumber *roleNum = [[NSNumber alloc]initWithInt:bean.role];
            NSArray *arr = [NSArray arrayWithObjects:indexSelected, roleNum, nil];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
            for (int i=0; i<[self.allPlayer count]; i++) {
                if (self.killIndex==i) {//说明当前为被杀用户，角色为-1
//                    roleNum = [[NSNumber alloc]initWithInt:-1];
                }
                PlayerBean *temp = [self.allPlayer objectAtIndex:i];
                SPYConnection *connection = temp.connection;
                [connection writeData:connection.output WithData:data OperType:SPYKillPlayerPush];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
