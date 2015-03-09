//
//  PlayerInfoViewController.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerInfoViewController.h"
#import "UIWindow+YzdHUD.h"

@interface PlayerInfoViewController ()

@end

@implementation PlayerInfoViewController{
    PlayerHeader *header;
}
@synthesize mainPlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
    
    CGFloat width = kMAIN_SCREEN_WIDTH;
    CGFloat height = kMAIN_SCREEN_HEIGHT;
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height+20;
    
    //主界面头部
    CGFloat currentY = barHeight;
    header = [[[NSBundle mainBundle] loadNibNamed:@"PlayerHeader" owner:self.view options:nil] lastObject];
    header.frame = CGRectMake(0, currentY, width, header.frame.size.height);
    [self.view addSubview:header];
    
    //游戏设置面板
    currentY += header.frame.size.height;
    self.mainGameView = [[[NSBundle mainBundle] loadNibNamed:@"GameInitionView" owner:self.view options:nil] lastObject];
    CGFloat plusY = [ActionView getViewHeight];
    self.mainGameView.frame = CGRectMake(0, currentY, width, height-barHeight-header.frame.size.height-plusY);
    self.mainGameView.contentSize = CGSizeMake(kMAIN_SCREEN_WIDTH, 388);
    self.mainGameView.scrollEnabled = YES;
    [self.mainGameView setShowsHorizontalScrollIndicator:NO];
    [self.mainGameView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.mainGameView];
    
    currentY += self.mainGameView.frame.size.height;
    
    //游戏控制按钮
    ActionView *actionView = [[ActionView alloc] init];
    [actionView setUpFrame:CGRectMake(0, currentY, width, height-barHeight-header.frame.size.height)];
    actionView.delegate = self;
    [self.view addSubview:actionView];
    
    
    //判断app是否未初始化过
    //如果尚未初始化，则进行初始化
    SPYFileUtil *util = [SPYFileUtil shareInstance];
    if ([util isUserDataExist]==NO) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==YES) {
            //弹出初始化视图
            SettingsBoardView *sv = [[SettingsBoardView alloc]initWithFrame:CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT)];
            [sv setupWithDelegate:self];
            [self presentViewController:sv.camera];
        }else{
            UIViewController *vc = [[UIViewController alloc]init];
            UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT)];
            [backgroundView setBackgroundColor:[UIColor blackColor]];
            backgroundView.alpha = .6;
            SettingsSubView *subview = [[[NSBundle mainBundle]loadNibNamed:@"SettingsSubView" owner:self options:nil]lastObject];
            subview.frame = CGRectMake((kMAIN_SCREEN_WIDTH-subview.frame.size.width)/2, (kMAIN_SCREEN_HEIGHT-subview.frame.size.height)/2, subview.frame.size.width, subview.frame.size.height);
            [backgroundView addSubview:subview];
            [vc setView:backgroundView];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
    //读取初始化数据
    NSString *name = [util getUserName];
    UIImage *headerData = [util getUserHeader];
    NSString *uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    self.mainPlayer = [PlayerBean initWithData:headerData Name:name DeviceName:[UIDevice currentDevice].name BeanID:uuid];
    self.mainPlayer.status = BLE_ONLINE;
    
    [header initWithPlayerBean:self.mainPlayer Delegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeaderData) name:@"reloadHeaderData" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) createServer{
    NSInteger totalNum = self.mainGameView.totalNum;
    NSInteger citizenNum = self.mainGameView.citizenNum;
    NSInteger whiteBoardNum = self.mainGameView.whiteBoardNum;
    NSInteger spyNum = totalNum - citizenNum - whiteBoardNum;
    
    GameRoomView *room = [[GameRoomView alloc] init];
    [room setupValues:totalNum SpyNum:spyNum CitizenNum:citizenNum WhiteboardNum:whiteBoardNum MainPlayer:self.mainPlayer asServer:YES];
    room.title = @"等待加入";
    
    [self.navigationController pushViewController:room animated:YES];
}

- (void) asClient{
    
    GameRoomView *room = [[GameRoomView alloc] init];
    [room setupValues:0 SpyNum:0 CitizenNum:0 WhiteboardNum:0 MainPlayer:self.mainPlayer asServer:NO];
    room.title = @"等待开始";
    
    [self.navigationController pushViewController:room animated:YES];
    
}

- (void) gotoHistoryList{
    HistoryListViewController *vc = [[HistoryListViewController alloc] init];
    vc.title = @"游戏记录";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) presentViewController:(UIViewController*)viewcontroller{
    [self presentViewController:viewcontroller animated:YES completion:nil];
}

- (void) dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadHeaderData{
    SPYFileUtil *util = [SPYFileUtil shareInstance];
    NSString *name = [util getUserName];
    UIImage *headerData = [util getUserHeader];
    
    self.mainPlayer.img = headerData;
    self.mainPlayer.name = name;
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}


@end
