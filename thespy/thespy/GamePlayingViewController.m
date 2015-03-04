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
#import "GameResult.h"
#import "GameDB.h"


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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.remoteData = [[NSArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(killPlayerRemote:) name:@"killPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(victory:) name:@"victory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver) name:@"gameover" object:nil];
    
    [self.roleLabel setHidden:YES];

    if (self.allPlayer) {
        for (int i=0; i<[self.allPlayer count]; i++) {
            PlayerBean *bean = self.allPlayer[i];
            bean.status = BLE_HIDDEN;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    if(self.alert){
        [self.alert dismissWithClickedButtonIndex:0 animated:NO];
    }
    //通知服务器，游戏界面已经退出，就绪
    NSNumber *num = [[NSNumber alloc]initWithInteger:self.index];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:num];
    [self.bean.connection writeData:self.bean.connection.output WithData:data OperType:SPYStatusReady];
}

-(void)gameOver{
    [self.alert dismissWithClickedButtonIndex:0 animated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)victoryWithType:(NSInteger)type{
    NSString *tip;
    switch (type) {
        case 1:{//平民
            tip = @"平民胜利！";
            break;
        }
        case 0:{//卧底
            tip = @"卧底胜利！";
            break;
        }
        case 2:{//白板
            tip = @"白板胜利！";
            break;
        }
        default:
            break;
    }
    BOOL selfWin = type==self.bean.role;
    NSString *role = [PlayerBean getRoleStringByPlayerRole:self.bean.role];
    //日期格式化
    NSDate *date = [NSDate date];
    NSString *gameResultID = [NSString stringWithFormat:@"%@.%f", self.bean.deviceName, [date timeIntervalSince1970]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [dateFormatter stringFromDate:date];
    GameResult *result = [[GameResult alloc]initWithPlayerID:gameResultID Name:self.bean.name Role:role Victory:selfWin?@"胜利":@"失败" Date:str];
    [[GameDB shareInstance]addGameResult:result];
    
    [self createAlertView:tip CancelTxt:@"确认" OtherTxt:nil Tag:1002];
}

-(void)victory:(NSNotification*)notification{
    NSNumber *num = (NSNumber*)[notification object];
    NSInteger type = [num integerValue];
    [self victoryWithType:type];
}

-(void)killPlayerRemote:(NSNotification*)notification{
    NSArray *arr = (NSArray*)[notification object];
    NSInteger index = [(NSNumber*)arr[0] integerValue];
    PlayerRole role = [(NSNumber*)arr[1] intValue];
    //判断该玩家是否已经被杀死
    //被杀死后不可再响应点击
    UIView *view = [self.scrollView viewWithTag:(2000+index)];
    if (view&&[view isKindOfClass:[GameRoomCell class]]) {
        GameRoomCell *cell = (GameRoomCell*)view;
        if (cell&&[cell.roleLabel isHidden]==NO) {
            return;
        }
    }
    
    //判断是否是自己被杀死
    if (index==self.index) {//是自己被杀死
        NSString *role = [PlayerBean getRoleStringByPlayerRole:self.bean.role];
        self.roleLabel.text = [NSString stringWithFormat:@"您 是 %@", role];
        [self.roleLabel setHidden:NO];
        [self setRoleAppear:self.index WithRole:self.bean.role];
    }else{//不是自己被杀死
        [self setRoleAppear:index WithRole:role];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    self.wordLabel.text = self.bean.word;
    self.show = YES;
    
    if (self.dataArr) {
        self.totalLabel.text = [NSString stringWithFormat:@"总数 %d 人", [self.dataArr[0] intValue]];
        self.citizenLabel.text = [NSString stringWithFormat:@"平民 %d 人", [self.dataArr[1] intValue]];
        self.spyLabel.text = [NSString stringWithFormat:@"卧底 %d 人", [self.dataArr[2] intValue]];
        self.whiteLabel.text = [NSString stringWithFormat:@"白板 %d 人", [self.dataArr[3] intValue]];
        
        self.totalNum = [self.dataArr[0] integerValue];
        self.citizenNum = [self.dataArr[1] integerValue];
        self.spyNum = [self.dataArr[2] integerValue];
        self.whiteNum = [self.dataArr[3] integerValue];
    }
    
    if (self.allPlayer&&[self.allPlayer count]>0) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.allPlayersView.frame];
        self.scrollView.scrollEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.contentSize = CGSizeMake(100, self.allPlayersView.frame.size.height);
        NSInteger y = 39;
        for (int i=0; i<[self.allPlayer count]; i++) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(killPlayer:)];
            tap.numberOfTouchesRequired = 1;//双击
            tap.numberOfTapsRequired = 1;//一个手指点击
            tap.delegate = self;

            GameRoomCell *gameRoomCell = [[[NSBundle mainBundle] loadNibNamed:@"GameRoomCell" owner:self options:nil] lastObject];
            gameRoomCell.frame = CGRectMake(10, y, gameRoomCell.frame.size.width, gameRoomCell.frame.size.height);
            [gameRoomCell setupWithData:[self.allPlayer objectAtIndex:i]];
            gameRoomCell.countLabel.text = [NSString stringWithFormat:@"%d", (i+1)];
            if (self.isServer) {
                [gameRoomCell addGestureRecognizer:tap];
            }
            [gameRoomCell setTag:(2000+i)];
            [self.scrollView addSubview:gameRoomCell];
            y += gameRoomCell.frame.size.height + 10;
        }
        self.scrollView.contentInset = UIEdgeInsetsMake(10, 0, self.scrollView.frame.size.height+self.scrollView.frame.origin.y-y, 0);
        [self.view insertSubview:self.scrollView aboveSubview:self.allPlayersView];
    }
    
    self.allPlayersView.layer.cornerRadius = 4;
    self.allPlayersView.layer.borderWidth = 1;
    self.allPlayersView.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    if (!self.isServer) {
        [self.tipsLabel setHidden:YES];
        [self.view insertSubview:self.tipsLabel aboveSubview:self.allPlayersView];
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
    [self createAlertView:title CancelTxt:@"确认" OtherTxt:@"再想想" Tag:1001];
    if ([room.countLabel.text intValue]>=1) {
        self.killIndex = [room.countLabel.text intValue] - 1;
    }else{
        self.killIndex = 0;
    }
    self.sender = sender;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger tag = alertView.tag;
    if (buttonIndex==0) {
        if (tag==1001) {
            //给被杀掉客户端发送被杀数据
            if ([self.allPlayer count]>0) {
                PlayerBean *bean = [self.allPlayer objectAtIndex:self.killIndex];
//                if (self.killIndex>0) {//self.killIndex>0说明被杀的不是主机,处理主机显示逻辑
                    [self setRoleAppear:self.killIndex WithRole:bean.role];
//                }
                
                NSNumber *indexSelected = [[NSNumber alloc]initWithInt:self.killIndex];
                NSNumber *roleNum = [[NSNumber alloc]initWithInt:bean.role];
                NSArray *arr = [NSArray arrayWithObjects:indexSelected, roleNum, nil];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
                for (int i=1; i<[self.allPlayer count]; i++) {
                    PlayerBean *temp = [self.allPlayer objectAtIndex:i];
                    SPYConnection *connection = temp.connection;
                    [connection writeData:connection.output WithData:data OperType:SPYKillPlayerPush];
                }
                
                if (bean.role==CITIZEN) {
                    self.citizenNum--;
                }else if(bean.role==SPY){
                    self.spyNum--;
                }else if(bean.role==WHITE){
                    self.whiteNum--;
                }
                [self isGameOver];
            }
        }
        if (tag==1000) {
            NSString *role = [PlayerBean getRoleStringByPlayerRole:self.bean.role];
            self.roleLabel.text = [NSString stringWithFormat:@"您 是 %@", role];
            [self.roleLabel setHidden:NO];
            [self setRoleAppear:self.index WithRole:self.bean.role];
        }
        if (tag==1002&&self.isServer) {//如果是服务器，点击确定后从新开始游戏
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.allPlayer) {
                for (int i=0; i<[self.allPlayer count]; i++) {
                    PlayerBean *bean = self.allPlayer[i];
                    SPYConnection *con = bean.connection;
                    [con writeData:con.output WithData:nil OperType:SPYGameAgainPush];
                }
            }
        }
    }
}

- (void)setRoleAppear:(NSInteger)index WithRole:(PlayerRole)role{
    UIView *view = [self.scrollView viewWithTag:(2000+index)];
    if (view&&[view isKindOfClass:[GameRoomCell class]]) {
        NSString *roleStr = [PlayerBean getRoleStringByPlayerRole:role];
        GameRoomCell *cell = (GameRoomCell*)view;
        cell.roleLabel.text = roleStr;
        [cell.roleLabel setHidden:NO];
    }
}

- (void)isGameOver{
    BOOL isOver = NO;
    NSNumber *victory;
    if (self.spyNum==0&&self.whiteNum==0) {//平民胜利
        victory = [[NSNumber alloc]initWithInteger:1];
        isOver = YES;
    }else if(self.citizenNum==0){//卧底胜利
        victory = [[NSNumber alloc]initWithInteger:0];
        isOver = YES;
    }else if(self.citizenNum==0&&self.spyNum==0){//白板胜利
        victory = [[NSNumber alloc]initWithInteger:2];
        isOver = YES;
    }
    //给所有用户发送游戏结束数据
    if (isOver) {
        for (int i=1; i<[self.allPlayer count]; i++) {
            PlayerBean *bean = [self.allPlayer objectAtIndex:i];
            SPYConnection *con = bean.connection;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:victory];
            [con writeData:con.output WithData:data OperType:SPYVictoryPush];
        }
        //处理本机逻辑
        [self victoryWithType:[victory integerValue]];
    }
}

- (void)createAlertView:(NSString*)title CancelTxt:(NSString*)cancelTxt OtherTxt:(NSString*)otherTxt Tag:(NSInteger)tag{
    if (self.alert) {
        [self.alert dismissWithClickedButtonIndex:0 animated:NO];
    }
    self.alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:cancelTxt otherButtonTitles:otherTxt, nil];
    self.alert.delegate = self;
    [self.alert setTag:tag];
    [self.alert show];
}

@end
