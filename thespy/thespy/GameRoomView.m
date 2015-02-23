//
//  GameRoomView.m
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameRoomView.h"
#import "SPYFileUtil.h"
#import "SPYConnection+Delegate.h"
#import "PlayerBean.h"

@implementation GameRoomView
@synthesize subRoomView;

-(void)dealloc{
    [self closeService];
}

- (void)viewDidAppear:(BOOL)animated{
    
    if (!self.asServer&&!self.isRemoteInit) {//如果是客户端，则弹出连接列表
        self.plvc = [[ServerListViewController alloc] init];
        self.plvc.title = @"选择要加入的游戏";
        self.plvc.delegate = self;
        [self.navigationController pushViewController:self.plvc animated:NO];
    }
    
    if ([self.subRoomView.allPlayer count]<=1&&!self.asServer) {//注册过的才可以拉取房间信息
        //初始化:
        self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        //设置显示样式,见UIActivityIndicatorViewStyle的定义
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        //设置显示位置
        [self.indicator setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
        //设置背景色
        self.indicator.backgroundColor = [UIColor blackColor];
        //设置背景透明
        self.indicator.alpha = 0.5f;
        //设置背景为圆角矩形
        self.indicator.layer.cornerRadius = 6;
        self.indicator.layer.masksToBounds = YES;
        //将初始化好的indicator add到view中
        [self.view addSubview:self.indicator];
        [self.indicator setHidesWhenStopped:YES];
        //开始显示Loading动画
        [self.indicator startAnimating];
    }
    
    //开始按钮
    if (self.asServer&&self.start==nil) {
        self.start = [[UIButton alloc] initWithFrame:CGRectMake(kMAIN_SCREEN_WIDTH/2-50, kMAIN_SCREEN_HEIGHT-80, 100, 50)];
        [self.start setTitle:@"开始游戏" forState:UIControlStateNormal];
        self.start.layer.cornerRadius = 4;
        self.start.backgroundColor = UIColorFromRGB(0xFF7F00);//ff7f00
        self.start.alpha = 0.4;
        [self.start addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:self.start aboveSubview:self.subRoomView.view];
        [self.start setHidden:YES];
    }
    
    self.onGame = NO;
//    [self.service startMonitoring];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat currentY = barHeight + 20;
    
    self.subRoomView = [[GameRoomSubview alloc] initWithNibName:@"GameRoomSubview" bundle:[NSBundle mainBundle]];
    self.subRoomView.view.frame = CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT-currentY);
    if (self.asServer) {
        [self.subRoomView setMainPlayer:self.mainPlayer];
    }
    [self addChildViewController:self.subRoomView];
    [self.view addSubview:self.subRoomView.view];
    
    self.gameRoomHeader = [[[NSBundle mainBundle] loadNibNamed:@"GameRoomHeader" owner:self options:nil] lastObject];
    self.gameRoomHeader.frame = CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, 117);
    [self updateOnlinePlayer];//更新当前参与人数
    self.gameRoomHeader.totalLabel.text = [NSString stringWithFormat:@"总人数 %d 人", (int)self.totalNum];
    self.gameRoomHeader.citizenLabel.text = [NSString stringWithFormat:@"平民数 %d 人", (int)self.citizenNum];
    self.gameRoomHeader.spyLabel.text = [NSString stringWithFormat:@"卧底数 %d 人", (int)self.spyNum];
    self.gameRoomHeader.whiteboardLabel.text = [NSString stringWithFormat:@"白板数 %d 人", (int)self.whiteBoardNum];
    [self.view insertSubview:self.gameRoomHeader aboveSubview:self.subRoomView.view];

    UIImage *image = [UIImage imageNamed:@"SpyResource.bundle/left_icon"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:@selector(closeCurrentGame)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.connections = [[NSMutableArray alloc]initWithCapacity:5];
    self.remainingToRead = -2;
    self.mdata = [[NSMutableData alloc]init];
    self.isRemoteInit = NO;
}


#pragma NetWorkingDelegate
-(void)dismissViewController{//取消连接列表
//    [self dismissModalViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) reloadClientListTable:(NSArray*)list{//刷新用户列表
    if (self.asServer&&(self.onGame||[self.subRoomView.allPlayer count]==self.totalNum)) {//如果服务器端当前正在游戏中,向客户端写回nil
        SPYConnection *conn = ((SPYConnection*)[self.connections lastObject]);
        [conn writeData:conn.output WithData:nil OperType:SPYGameRoomInfoPush];
        [self.connections removeLastObject];
        return;
    }
    if (self.asServer==NO&&list==nil) {//说明服务器拒接自己连接
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能加入正在进行的游戏！" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        alert.delegate = self;
        [alert setTag:101];
        [alert show];
    }
    if (list) {
        for (int i=0; i<[list count]; i++) {
            NSInteger index = [self.subRoomView.allPlayer count];
            if ([list[i] isKindOfClass:[PlayerBean class]]) {
                PlayerBean *bean = (PlayerBean*)list[i];
                NSNumber *num = [[NSNumber alloc]initWithInteger:(index+i)];
                [bean setIndex:num];
                [self.subRoomView.allPlayer addObject:bean];
            }
        }
    }
    [self.subRoomView.collectionView reloadData];
    [self updateOnlinePlayer];
    if (!self.asServer&&[self.indicator isAnimating]) {
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
        NSLog(@"stop...........is...........called............");
    }
    if (self.asServer) {
        //向新注册用户写回当前在线用户数据
        //房间数据
        NSString *total = [NSString stringWithFormat:@"%d", (int)self.totalNum];
        NSString *citizen = [NSString stringWithFormat:@"%d", (int)self.citizenNum];
        NSString *spy = [NSString stringWithFormat:@"%d", (int)self.spyNum];
        NSString *white = [NSString stringWithFormat:@"%d", (int)self.whiteBoardNum];
        NSNumber *currentIndex = [[NSNumber alloc]initWithInteger:[self.subRoomView.allPlayer count]-1];
        NSArray *roomarr = [NSArray arrayWithObjects:total, citizen, spy, white, currentIndex, nil];
        //当前在线用户
        NSMutableArray *arr = self.subRoomView.allPlayer;
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:roomarr, @"roomarr", arr, @"players", nil];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        SPYConnection *conn = ((SPYConnection*)[self.connections lastObject]);
        [conn writeData:conn.output WithData:data OperType:SPYGameRoomInfoPush];
        
        //向其他已连接客户端写出新用户数据
        NSMutableArray *others = self.connections;
        if (others&&[others count]>1) {
            for (int i=0; i<[others count]-1; i++) {
                SPYConnection *con = (SPYConnection*)others[i];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[list firstObject]];
                [con writeData:con.output WithData:data OperType:SPYNewPlayerPush];
            }
        }
    }

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
        if (!self.isServerOpen) {
            NSString *deviceName = [UIDevice currentDevice].name;
            self.service = [[NSNetService alloc] initWithDomain:@"local." type:@"_thespy._tcp." name:[NSString stringWithFormat:@"%@ 的游戏",deviceName]];
            self.service.includesPeerToPeer = NO;
            [self.service setDelegate:self];
            [self.service scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [self.service publishWithOptions:NSNetServiceListenForConnections];
        }
    }
}

- (void) updateOnlinePlayer{
    self.gameRoomHeader.currentLabel.text = [NSString stringWithFormat:@"%d", (int)[self.subRoomView.allPlayer count]];
    if (self.asServer&&[self.subRoomView.allPlayer count]==self.totalNum) {//判断是否满足开始条件
        [self.start setHidden:NO];
    }
    
}

- (void)closeCurrentGame{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确认要终止游戏吗？" message:@"" delegate:self cancelButtonTitle:@"终止" otherButtonTitles:@"算了", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSInteger tag = [alertView tag];
        if (tag==101&&!self.asServer) {//被服务器拒接
            self.plvc = [[ServerListViewController alloc] init];
            self.plvc.title = @"选择要加入的游戏";
            self.plvc.delegate = self;
            [self.navigationController pushViewController:self.plvc animated:NO];
            return;
        }
        if (self.asServer) {
            [self closeService];
        }else{
            //向服务器发送终止游戏数据
            NSNumber *num = self.mainPlayer.index;
            if (self.connection) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:num];
                [self.connection writeData:self.connection.output WithData:data OperType:SYPClientLeavePush];
                [self.connection closeConnection];
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)addSPYConnection:(SPYConnection *)conn{
    [self.connections addObject:conn];
}

- (void) closeService{
    if (self.asServer) {
        NSMutableArray *conns = self.connections;
        if ([conns count]>0) {
            for (int i=0; i<[conns count]; i++) {
                SPYConnection *con = conns[i];
                [con writeData:con.output WithData:nil OperType:SPYServerOutPush];
            }
        }
    }
    
    [self.connection closeConnection];
    self.connections = nil;
    [self.service removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.service setDelegate:nil];
    [self.service stop];
    self.isServerOpen = NO;
    NSLog(@"SPYService is stop...");
}

//服务发布成功后回调
- (void) netServiceDidPublish:(NSNetService *)sender{
    self.isServerOpen = YES;
}

//获得客户端连接，建立连接并保存
- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        SPYConnection *connection = [[SPYConnection alloc] initWithInput:inputStream output:outputStream delegate:self];
        [self.connections addObject:connection];
    }];
}

- (void) publishServer{
    NSString *deviceName = [UIDevice currentDevice].name;
    self.service = [[NSNetService alloc] initWithDomain:@"local." type:@"_thespy._tcp." name:[NSString stringWithFormat:@"%@-->创建的游戏",deviceName]];
    self.service.includesPeerToPeer = NO;
    [self.service setDelegate:self];
    [self.service scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.service publishWithOptions:NSNetServiceListenForConnections];
    
//    [self.service ]
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict{
    self.isServerOpen = NO;
}

//连接到选定的服务器
- (void)connectToServer:(NSNetService*)service{
    BOOL                success;
    NSInputStream *     inputs;
    NSOutputStream *    outputs;

    self.service = service;
    self.service.delegate = self;
    success = [self.service getInputStream:&inputs outputStream:&outputs];
    if (success) {
        self.connection = [[SPYConnection alloc]initWithInput:inputs output:outputs delegate:self];
    }
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser
            didFindService:(NSNetService *)netService
                moreComing:(BOOL)moreServicesComing{
    if ( ! [self.plvc.servers containsObject:netService] ) {
        [self.plvc.servers addObject:netService];
    }
    if ( moreServicesComing ) {
        return;
    }
    [self.plvc.tableView reloadData];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser
         didRemoveService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing{
    [self.plvc.servers removeObject:netService];
    if ( moreServicesComing ) {
        return;
    }
    [self.plvc.tableView reloadData];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            self.streamOpenCount++;
            break;
        case NSStreamEventHasSpaceAvailable:{
            if (self.streamOpenCount==2&&self.asServer==NO&&[aStream isKindOfClass:[NSOutputStream class]]&&!self.isRemoteInit) {//说明输入输出流都已经开启完毕
                //发送本机数据到服务器
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.mainPlayer];
                
                [[SPYConnection alloc]writeData:(NSOutputStream*)aStream WithData:data OperType:SPYNewPlayerPush];
                self.isRemoteInit = YES;
                [self.navigationController popViewControllerAnimated:NO];
            }
            break;
        }
        case NSStreamEventHasBytesAvailable:{//读取数据
            if ([aStream isKindOfClass:[NSInputStream class]]){
                NSInputStream *in = (NSInputStream*)aStream;
                uint8_t buf[32768];
                NSInteger readLength = [in read:buf maxLength:sizeof(buf)];
                if (readLength>0) {
                    NSData *tmp = [NSData dataWithBytes:buf length:readLength];
                    [self.mdata appendData:tmp];
                    
                    if ([self.mdata length]>4&&self.remainingToRead<=0) {//当读取的数据大于4字节后，读取数据包长度数据
                        uint8_t buf[4];
                        [self.mdata getBytes:buf range:NSMakeRange(0, 4)];
                        self.remainingToRead = ((buf[0]<<24)&0xff000000)+((buf[1]<<16)&0xff0000)+((buf[2]<<8)&0xff00)+(buf[3] & 0xff);
                    }
                    if ([self.mdata length]>=self.remainingToRead) {//说明数据已经读取完毕
                        uint8_t buf[1];
                        [self.mdata getBytes:buf range:NSMakeRange(4, 1)];
                        int oper = buf[0]&0xff;
                        NSData *data;
                        if ([self.mdata length]>5) {
                            data = [self.mdata subdataWithRange:NSMakeRange(5, self.remainingToRead-5)];
                        }
                        [[SPYConnection alloc]operation:oper WithData:data Delegate:self];
                        
                        if (self.remainingToRead>[self.mdata length]) {
                            NSData *subs = [self.mdata subdataWithRange:NSMakeRange(self.remainingToRead-1, [self.mdata length]-self.remainingToRead)];
                            if ([subs length]>0) {
                                self.mdata = [NSMutableData dataWithData:subs];
                            }
                        }else{
                            self.mdata = [[NSMutableData alloc]init];
                        }
                        self.remainingToRead = 0;
                    }
                }
            }
            break;
        }
        case NSStreamEventErrorOccurred:{
            //出错的时候
//            NSError *error = [aStream streamError];
//            if (error != NULL){
//                UIAlertView *errorAlert = [[UIAlertView alloc]
//                                           initWithTitle: [error localizedDescription]
//                                           message: [error localizedFailureReason]
//                                           delegate:nil
//                                           cancelButtonTitle:@"OK"
//                                           otherButtonTitles:nil];
//                [errorAlert show];
//            }
            break;
        }
        default:
            break;
    }
}

-(void)initGameRoomData:(NSArray*)arr{
    NSString *total = arr[0];
    NSString *citizen = arr[1];
    NSString *spy = arr[2];
    NSString *white = arr[3];
    NSNumber *index = arr[4];
    
    self.totalNum = [total integerValue];
    self.citizenNum = [citizen integerValue];
    self.spyNum = [spy integerValue];
    self.whiteBoardNum = [white integerValue];
    
    self.gameRoomHeader.totalLabel.text = [NSString stringWithFormat:@"总人数 %d 人", [total intValue]];
    self.gameRoomHeader.citizenLabel.text = [NSString stringWithFormat:@"平民数 %d 人", [citizen intValue]];
    self.gameRoomHeader.spyLabel.text = [NSString stringWithFormat:@"卧底数 %d 人", [spy intValue]];
    self.gameRoomHeader.whiteboardLabel.text = [NSString stringWithFormat:@"白板数 %d 人", [white intValue]];
    
    self.mainPlayer.index = index;
    
}

-(void)serverIsOut{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"主机已经退出游戏" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)startGame{
    //获得词条对
    NSString *spyWord = @"地球";
    NSString *citizenWord = @"月亮";
    
    NSMutableArray *allPlayers = [[NSMutableArray alloc]initWithArray:self.subRoomView.allPlayer];
    NSMutableArray *allCon = [[NSMutableArray alloc]initWithArray:self.connections];
    [allCon insertObject:[[SPYConnection alloc]init] atIndex:0];//占位，自己排第一位，不需要连接
    
    if ([allPlayers count]==self.totalNum&&[allCon count]==self.totalNum) {
        //封装游戏数据对象
        NSMutableArray *indexArr = [[NSMutableArray alloc]initWithCapacity:[allPlayers count]];
        int citizen = [[[NSNumber alloc]initWithInteger:CITIZEN]intValue];
        int spy = [[[NSNumber alloc]initWithInteger:SPY]intValue];
        int white = [[[NSNumber alloc]initWithInteger:WHITE]intValue];
        //封装平民
        for (int i=0; i<self.citizenNum; i++) {
            
            NSArray *a = [NSArray arrayWithObjects:citizenWord, [NSString stringWithFormat:@"%d", citizen], nil];
            [indexArr addObject:a];
        }
        //封装卧底
        for (int i=0; i<self.spyNum; i++) {
            NSArray *b = [NSArray arrayWithObjects:spyWord, [NSString stringWithFormat:@"%d", spy], nil];
            [indexArr addObject:b];
        }
        //封装白板
        for (int i=0; i<self.whiteBoardNum; i++) {
            NSArray *c = [NSArray arrayWithObjects:@"您是白板", [NSString stringWithFormat:@"%d", white], nil];
            [indexArr addObject:c];
        }
        
        //打乱角色数据
        NSMutableArray *newRoles = [[NSMutableArray alloc]initWithCapacity:[indexArr count]];
        while([indexArr count]>0){
            int value = arc4random() % [indexArr count];
            [newRoles addObject:indexArr[value]];
//            [indexArr removeObject:indexArr[value]];
            [indexArr removeObjectAtIndex:value];
        }
        
        //为所有用户分配角色,并发送游戏开始数据
        for (int i=0; i<[allPlayers count]; i++) {
            PlayerBean *bean = allPlayers[i];
//            NSNumber *num= [[NSNumber alloc]initWithInt:i];
//            [bean setIndex:num];
            SPYConnection *con = allCon[i];
            [bean setConnection:con];
            NSArray *arr = newRoles[i];
            [bean setWord:(NSString*)arr[0]];
            NSString *rolestr = (NSString*)arr[1];
            [bean setRole:[rolestr intValue]];
            
            //发送数据
            if(i==0){//本机数据
                [self startRemoteGame:bean];
            }else{//客户端数据
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bean];
                [con writeData:con.output WithData:data OperType:SPYGameStartPush];
            }
        }
        indexArr = nil;
        allPlayers = nil;
        newRoles = nil;
        
        self.onGame = YES;
//        [self.service stopMonitoring];]
    }
}

-(void)startRemoteGame:(PlayerBean*)bean{
    
    GamePlayingViewController *gpvc = [[GamePlayingViewController alloc] initWithNibName:@"GamePlayingViewController" bundle:[NSBundle mainBundle]];
    NSNumber *totalNum = [[NSNumber alloc]initWithInteger:self.totalNum];
    NSNumber *citizenNum = [[NSNumber alloc]initWithInteger:self.citizenNum];
    NSNumber *spyNum = [[NSNumber alloc]initWithInteger:self.spyNum];
    NSNumber *whiteNum = [[NSNumber alloc]initWithInteger:self.whiteBoardNum];
    NSArray *arr = [NSArray arrayWithObjects:totalNum, citizenNum, spyNum, whiteNum, nil];
    [gpvc setUpFrame:bean WithOthers:self.subRoomView.allPlayer WithGameInfo:arr AsServer:self.asServer];
//    gpvc.superGameView = self;
    
    [self presentViewController:gpvc animated:YES completion:nil];
}

-(void)killPlayerWithArr:(NSArray*)arr{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"killPlayer" object:arr];
}

-(void)victory:(NSNumber*)type{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"victory" object:type];
}

-(void)gameAgain{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameagain" object:nil];
}

-(void)clientLeave:(NSNumber*)index{
    if (index&&self.asServer) {
        [self.subRoomView.allPlayer removeObjectAtIndex:[index integerValue]];
        [self.subRoomView.collectionView reloadData];
        [self updateOnlinePlayer];
        //向其余客户端发送消息
        if([self.subRoomView.allPlayer count]>1){
            for (int i=1; i<[self.subRoomView.allPlayer count]; i++) {
                PlayerBean *bean = self.subRoomView.allPlayer[i];
                SPYConnection *con = bean.connection;
                if (con) {
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:index];
                    [con writeData:con.output WithData:data OperType:SYPClientLeavePush];
                }
            }
        }
    }
    
}

@end
