//
//  GameRoomView.m
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameRoomView.h"

@implementation GameRoomView
@synthesize subRoomView;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat currentY = barHeight + 20;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, 30)];
    title.text = [NSString stringWithFormat:@"总人数:%d,平民:%d,卧底:%d,白板:%d", (int)_totalNum, (int)_citizenNum,(int) _spyNum, (int)_whiteBoardNum];
    title.backgroundColor = [UIColor darkGrayColor];
    title.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:title];
    currentY += 30;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, 5)];
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    currentY += 5;
    
    UILabel *nowPlayer = [[UILabel alloc]initWithFrame:CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH/2, 30)];
    nowPlayer.text = @"目前参与人数:";
    nowPlayer.backgroundColor = [UIColor darkGrayColor];
    nowPlayer.textAlignment = UITextAlignmentRight;
    [self.view addSubview:nowPlayer];
    
    self.nowPlayerNum = [[UILabel alloc] initWithFrame:CGRectMake(nowPlayer.frame.size.width, currentY, kMAIN_SCREEN_WIDTH/2, 30)];
    self.nowPlayerNum.text = @"1";
    self.nowPlayerNum.backgroundColor = [UIColor darkGrayColor];
    self.nowPlayerNum.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:self.nowPlayerNum];
    currentY += 30;
    
    self.subRoomView = [[GameRoomSubview alloc] initWithNibName:@"GameRoomSubview" bundle:[NSBundle mainBundle]];
    self.subRoomView.view.frame = CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT-currentY);
    [self.subRoomView setMainPlayer:self.mainPlayer];
    [self addChildViewController:self.subRoomView];
    [self.view addSubview:self.subRoomView.view];
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(closeService)];
    UIImage *image = [UIImage imageNamed:@"SpyResource.bundle/left_icon"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:@selector(closeService)];
    leftButton.title = @"退出游戏";
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void) reloadClientListTable:(PlayerBean*)player{
    [self.subRoomView.allPlayer addObject:player];
    [self.subRoomView.collectionView reloadData];
//    [self.subRoomView reloadInputViews];
    [self updateOnlinePlayer];
}

- (void)setupValues:(NSInteger)totalNum SpyNum:(NSInteger)spyNum CitizenNum:(NSInteger)citizenNum WhiteboardNum:(NSInteger)whiteBoardNum MainPlayer:(PlayerBean *)mainPlayer asServer:(BOOL)asServer{
    self.totalNum = totalNum;
    self.spyNum = spyNum;
    self.citizenNum = citizenNum;
    self.whiteBoardNum = whiteBoardNum;
    self.mainPlayer = mainPlayer;
    
    self.otherPlayer = [[NSMutableArray alloc] initWithCapacity:5];
    
    self.asServer = asServer;
    if (self.asServer) {
        self.server = [SPYService shareInstance];
        self.server.delegate = self;
        if (!self.server.isServerOpen) {
            [self.server publishServer];
        }
    }
}

- (void) updateOnlinePlayer{
    self.nowPlayerNum.text = [NSString stringWithFormat:@"%d", (int)[self.subRoomView.allPlayer count]];
}

- (void)closeService{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确认要终止游戏吗？" message:@"" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"终止", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.server closeService];
        [self.connection closeConnection];
        self.connections = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
