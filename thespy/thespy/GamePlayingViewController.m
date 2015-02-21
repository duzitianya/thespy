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

- (instancetype)init{
    self = [super init];
    if (self) {
//        [self.bean addObserver:<#(NSObject *)#> forKeyPath:<#(NSString *)#> options:<#(NSKeyValueObservingOptions)#> context:<#(void *)#>
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(killPlayer:)];
    self.doubleTap.numberOfTouchesRequired = 1;//双击
    self.doubleTap.numberOfTapsRequired = 1;//一个手指点击
    self.doubleTap.delegate = self;
    
    self.remoteData = [[NSArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(killPlayerRemote:) name:@"killPlayer" object:nil];
    
    [self.roleLabel setHidden:YES];
}

-(void)killPlayerRemote:(NSNotification*) notification{
    NSArray *arr = (NSArray*)[notification object];
    NSInteger index = [(NSNumber*)arr[0] integerValue];
    PlayerRole role = [(NSNumber*)arr[1] intValue];
    //判断是否是自己被杀死
    NSLog(@"index--->%d, self.bean.index--->%d", (int)index, (int)self.index);
    if (index==self.index) {//是自己被杀死
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您已经被选中出局" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        alert.delegate = self;
        [alert setTag:1000];
        [alert show];
    }else{//不是自己被杀死
        [self setRoleAppear:index WithRole:role];
    }
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
            [gameRoomCell setTag:(2000+i)];
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
    
    self.roleLabel.layer.borderWidth = 2;
    self.roleLabel.layer.borderColor = [[UIColor redColor]CGColor];
    self.roleLabel.transform = CGAffineTransformMakeRotation(M_1_PI*-1);
}

-(void)setUpFrame:(PlayerBean*)bean WithOthers:(NSMutableArray*)others WithGameInfo:(NSArray*)arr AsServer:(BOOL)asServer{
    self.bean = bean;
    self.allPlayer = others;
    self.dataArr = arr;
    self.isServer = asServer;
    self.index = [bean.index integerValue];
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
    [alert setTag:1001];
    [alert show];
    if ([room.countLabel.text intValue]>=1) {
        self.killIndex = [room.countLabel.text intValue] - 1;
    }else{
        self.killIndex = 0;
    }
    //被杀死后不可再响应点击
    [room removeGestureRecognizer:sender];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger tag = alertView.tag;
    if (buttonIndex==0) {
        if (tag==1001) {
            //给被杀掉客户端发送被杀数据
            if ([self.allPlayer count]>0) {
                PlayerBean *bean = [self.allPlayer objectAtIndex:self.killIndex];
                if (self.killIndex>0) {//self.killIndex>0说明被杀的不是主机,处理主机显示逻辑
                    [self setRoleAppear:self.killIndex WithRole:bean.role];
                }
                
                NSNumber *indexSelected = [[NSNumber alloc]initWithInt:self.killIndex];
                NSNumber *roleNum = [[NSNumber alloc]initWithInt:bean.role];
                NSArray *arr = [NSArray arrayWithObjects:indexSelected, roleNum, nil];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
                for (int i=0; i<[self.allPlayer count]; i++) {
                    PlayerBean *temp = [self.allPlayer objectAtIndex:i];
                    SPYConnection *connection = temp.connection;
                    [connection writeData:connection.output WithData:data OperType:SPYKillPlayerPush];
                }
            }
        }
        if (tag==1000) {
//            [self dismissViewControllerAnimated:YES completion:nil];
            NSString *role = [PlayerBean getRoleStringByPlayerRole:self.bean.role];
            self.roleLabel.text = [NSString stringWithFormat:@"您 是 %@", role];
            [self.roleLabel setHidden:NO];
            [self setRoleAppear:self.index WithRole:self.bean.role];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)setRoleAppear:(NSInteger)index WithRole:(PlayerRole)role{
    UIView *view = [self.allPlayersView viewWithTag:(2000+index)];
    if (view&&[view isKindOfClass:[GameRoomCell class]]) {
        NSString *roleStr = [PlayerBean getRoleStringByPlayerRole:role];
        GameRoomCell *cell = (GameRoomCell*)view;
        cell.roleLabel.text = roleStr;
        [cell.roleLabel setHidden:NO];
    }
}

- (void)isGameOver{
    
}

@end
