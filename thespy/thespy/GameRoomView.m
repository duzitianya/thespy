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
#import "UIWindow+YzdHUD.h"
#import "SPYAlertView.h"

@implementation GameRoomView
@synthesize subRoomView;

-(void)dealloc{
    [self closeService];
    if (!self.asServer) {
        [self.connection closeConnection];
        self.connection = nil;
        self.clientAlive = NO;
        self.streamOpenCount = 0;
        self.isRemoteInit = NO;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[SPYAlertView shareInstance]dismissAlertView];
    self.plvc.delegate = nil;
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    if (!self.asServer&&!self.isRemoteInit) {//如果是客户端，则弹出连接列表
        self.clientAlive = NO;
        self.plvc = [[ServerListViewController alloc] init];
        self.plvc.title = @"选择要加入的游戏";
        self.plvc.delegate = self;
        [self.navigationController pushViewController:self.plvc animated:NO];
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
    self.readyCount = 1;
    
    //异步获得词条
    [self performSelectorInBackground:@selector(initGameWord) withObject:nil];
    
    //将用户置为连接中状态
//    if (self.subRoomView.allPlayer) {
//        for (int i=1; i<[self.subRoomView.allPlayer count]; i++) {
//            PlayerBean *bean = self.subRoomView.allPlayer[i];
//            bean.status = BLE_CONNECTTING;
//        }
//    }
}

- (void)initGameWord{
    //获得词条对
    NSArray *words = [[SPYFileUtil shareInstance]getWords];
    self.citizenWord = words[0];
    self.spyWord = words[1];
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
    self.isRemoteInit = NO;
    self.readMap = [[NSMutableDictionary alloc]initWithCapacity:2];
}

- (void) viewWillDisappear:(BOOL)animated{
//    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
}

#pragma NetWorkingDelegate
-(void)dismissViewController{//取消连接列表
    [self.navigationController popViewControllerAnimated:NO];
    self.clientAlive = NO;
    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
}

- (void) reloadClientListTable:(NSArray*)list{//刷新用户列表
//    @synchronized(self){
        if (self.asServer&&(self.onGame||[self.subRoomView.allPlayer count]==self.totalNum)) {//如果服务器端当前正在游戏中,向客户端写回nil
            SPYConnection *conn = [self.connections lastObject];
            [conn writeData:conn.output WithData:nil OperType:SPYGameRoomInfoPush];
            [self.connections removeObject:conn];
            return;
        }
        if (self.asServer==NO&&list==nil) {//说明服务器拒接自己连接
            [[SPYAlertView shareInstance]createAlertView:@"无法加入" Message:@"您不能加入正在进行的游戏！" CancelTxt:@"知道了" OtherTxt:@"" Tag:101 Delegate:self];
        }
        if (list) {
            for (int i=0; i<[list count]; i++) {
                NSInteger index = [self.subRoomView.allPlayer count];
                if ([list[i] isKindOfClass:[PlayerBean class]]) {
                    PlayerBean *bean = (PlayerBean*)list[i];
    //                if (self.asServer) {
    //                    bean.status = BLE_CONNECTTING;
    //                }else{
    //                    bean.status = BLE_HIDDEN;
    //                }
                    NSNumber *num = [[NSNumber alloc]initWithInteger:(index+i)];
                    [bean setIndex:num];
                    [self.subRoomView.allPlayer addObject:bean];
                }
            }
        }
        [self.subRoomView.collectionView reloadData];
        [self updateOnlinePlayer];
        if (!self.asServer) {
            [self.view.window showHUDWithText:@"加载成功" Type:ShowPhotoYes Enabled:YES];
            
            //新启动后台线程验证
            //    NSThread *backValidate = [[NSThread alloc]initWithTarget:self selector:@selector(validateRemoteList) object:nil];
    //        [self performSelectorInBackground:@selector(validateRemoteList) withObject:nil];
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
            SPYConnection *conn = [self.connections lastObject];
            [conn writeData:conn.output WithData:data OperType:SPYGameRoomInfoPush];
            
            //向其他已连接客户端写出新用户数据
            NSMutableArray *others = self.connections;
            if (others&&[others count]>1) {
                for (int i=0; i<[others count]-1; i++) {
                    SPYConnection *con = (SPYConnection*)others[i];
                    if (con==conn) {
                        continue;
                    }
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[list firstObject]];
                    [con writeData:con.output WithData:data OperType:SPYNewPlayerPush];
                }
            }
        }
//    }

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
    if (self.asServer&&[self.subRoomView.allPlayer count]==self.totalNum/*&&self.readyCount==[self.subRoomView.allPlayer count]*/) {//判断是否满足开始条件
        [self.start setHidden:NO];
    }else{
        [self.start setHidden:YES];
    }
    
}

- (void)closeCurrentGame{
    [[SPYAlertView shareInstance]createAlertView:@"您确认要终止游戏吗？" Message:@"" CancelTxt:@"终止" OtherTxt:@"算了" Tag:0 Delegate:self];
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
        
        if (tag!=20140620) {
            //向服务器发送终止游戏数据
            NSNumber *num = self.mainPlayer.index;
            if (self.connection) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:num];
                [self.connection writeData:self.connection.output WithData:data OperType:SYPClientLeavePush];
                [self.connection closeConnection];
            }
        }else{
            [self closeService];
        }

        [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
        if(self.clientAlive){
            [self gameOver];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
    [self.service removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.service stop];
    [self.service setDelegate:nil];
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
//        [self.connections addObject:connection];
        NSLog(@"Accept connections--->%d, %d", (int)[inputStream hasBytesAvailable], (int)[outputStream hasSpaceAvailable]);
//        if ([self.tempconns count]<=1) {
//            [self.tempconns addObject:connection];
//        }
//        [self.tempconns addObject:connection];
        if (self.tempconn==nil) {
            self.tempconn = connection;
        }
    }];
}

- (void) publishServer{
    NSString *userName = [[SPYFileUtil shareInstance]getUserName];
    if (userName||[userName length]==0) {
        userName = [UIDevice currentDevice].name;
    }
    self.service = [[NSNetService alloc] initWithDomain:@"local." type:@"_thespy._tcp." name:[NSString stringWithFormat:@"%@-->创建的游戏",userName]];
    self.service.includesPeerToPeer = NO;
    [self.service setDelegate:self];
    [self.service scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.service publishWithOptions:NSNetServiceListenForConnections];
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
//    [self.service resolveWithTimeout:100];
    if (success) {
        self.connection = [[SPYConnection alloc]initWithInput:inputs output:outputs delegate:self];
    }
}

//- (void) netServiceDidResolveAddress:(NSNetService *)sender{
//    NSInputStream *     inputs;
//    NSOutputStream *    outputs;
//    
//    NSString *host = [sender hostName];
//    NSInteger port = [sender port];
//    [NSStream getStreamsToHostNamed:host port:port inputStream:&inputs outputStream:&outputs];
//    if (inputs!=nil&&outputs!=nil) {
//        self.connection = [[SPYConnection alloc]initWithInput:inputs output:outputs delegate:self];
//    }
//}

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
    //如果取消的是选中的服务，则需要将客户端的状态指示器关闭
    NSUInteger index = [self.plvc.servers indexOfObject:netService];
    [self.plvc serverDidRemove:index];
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
                [self performSelectorInBackground:@selector(readRemoteDataWithStream:) withObject:in];
            }
            break;
        }
        case NSStreamEventErrorOccurred:{
            //出错的时候
            NSError *error = [aStream streamError];
            if (error != NULL){
                NSLog(@"##==%@", [error localizedDescription]);
                NSLog(@"##==%d", (int)[aStream streamStatus]);
            }
            if(self.asServer==NO&&self.isRemoteInit){
                [[SPYAlertView shareInstance]createAlertView:@"网络出现异常" Message:@"" CancelTxt:@"知道了" OtherTxt:nil Tag:0 Delegate:self];
            }
            break;
        }
        case NSStreamEventEndEncountered:{
            if (self.asServer==NO) {
                [self.view.window showHUDWithText:@"连接失败" Type:ShowPhotoNo Enabled:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        default:
            break;
    }
}

-(void)readRemoteDataWithStream:(NSInputStream *)in{
    NSString *key = [in description];
    NSMutableArray *mreadarr = [self.readMap objectForKey:key];
    
    BOOL isFirst = NO;
    if (mreadarr==nil){//说明第一次连接
        isFirst = YES;
        NSNumber *num = [[NSNumber alloc]initWithInteger:-1];
        mreadarr = [[NSMutableArray alloc]initWithObjects:num, [[NSMutableData alloc]init], nil];
        [self.readMap setObject:mreadarr forKey:key];
        
//        SPYConnection *con;
//        //根据输入流获得临时连接列表中对应的连接
//        if([self.tempconns count]>0){
//            con = self.tempconns[0];
//            [self.connections addObject:con];
//        }
        //判断self.connections中是否已经包含该连接，如果不包含，则放入该连接
//        if(con!=nil&&[self.connections containsObject:con]==NO){
//            [self.connections addObject:con];
//        }
//        [self.tempconns removeAllObjects];
    }
    
    uint8_t buf[32768];
    NSInteger readLength = [in read:buf maxLength:sizeof(buf)];
    if (readLength>0) {
        if(isFirst&&self.asServer&&self.tempconn!=nil){
            [self.connections addObject:self.tempconn];
            self.tempconn = nil;
        }
        
        NSInteger remainToRead = [mreadarr[0] integerValue];
        NSMutableData *mdata = mreadarr[1];
        NSData *tmp = [NSData dataWithBytes:buf length:readLength];
        [mdata appendData:tmp];
        
        if ([mdata length]>4&&remainToRead<=0) {//当读取的数据大于4字节后，读取数据包长度数据
            uint8_t buf[4];
            [mdata getBytes:buf range:NSMakeRange(0, 4)];
            remainToRead = ((buf[0]<<24)&0xff000000)+((buf[1]<<16)&0xff0000)+((buf[2]<<8)&0xff00)+(buf[3] & 0xff);
            
            NSNumber *num = [[NSNumber alloc]initWithInteger:remainToRead];
            [mreadarr replaceObjectAtIndex:0 withObject:num];
        }
        if ([mdata length]>=remainToRead) {//说明数据已经读取完毕
//            NSLog(@"total read--->%d, need to read--->%d", (int)[mdata length], (int)remainToRead);
            uint8_t buf[1];
            [mdata getBytes:buf range:NSMakeRange(4, 1)];
            int oper = buf[0]&0xff;
            NSData *data;
            if ([mdata length]>5) {
                data = [mdata subdataWithRange:NSMakeRange(5, remainToRead-5)];
            }
            [[SPYConnection alloc]operation:oper WithData:data Delegate:self];
            
            [self.readMap removeObjectForKey:[in description]];
        }
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
    
    //向服务器发送更新状态请求
//    if (self.asServer==NO) {
//        NSNumber *num = self.mainPlayer.index;
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:num];
//        [self.connection writeData:self.connection.output WithData:data OperType:SPYStatusReady];
//    }
}

//判断从服务器拉取的用户列表是否正确
-(void)validateRemoteList{
//    NSLog(@"Validate in background.....");
    NSNumber *allCount = [[NSNumber alloc]initWithInteger:[self.subRoomView.allPlayer count]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allCount];
    [self.connection writeData:self.connection.output WithData:data OperType:SYPConfirmPlayerList];
}

-(void)serverIsOut{
    [[SPYAlertView shareInstance]createAlertView:@"主机已经退出游戏" Message:@"" CancelTxt:@"知道了" OtherTxt:nil Tag:20140620 Delegate:self];
}

-(void)startGame{
    if (self.citizenWord==nil||[self.citizenWord length]==0) {
        [self initGameWord];
    }
    
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
            NSArray *a = [NSArray arrayWithObjects:self.citizenWord, [NSString stringWithFormat:@"%d", citizen], nil];
            [indexArr addObject:a];
        }
        //封装卧底
        for (int i=0; i<self.spyNum; i++) {
            NSArray *b = [NSArray arrayWithObjects:self.spyWord, [NSString stringWithFormat:@"%d", spy], nil];
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
            [indexArr removeObjectAtIndex:value];
        }
        
        //为所有用户分配角色,并发送游戏开始数据
        for (int i=0; i<[allPlayers count]; i++) {
            PlayerBean *bean = allPlayers[i];
            SPYConnection *con = allCon[i];
            [bean setConnection:con];
            NSArray *arr = newRoles[i];
            [bean setWord:(NSString*)arr[0]];
            NSString *rolestr = (NSString*)arr[1];
            [bean setRole:[rolestr intValue]];
            
            NSArray *dataarr = [[NSArray alloc]initWithObjects:arr[0], rolestr, nil];
            //发送数据
            if(i==0){//本机数据
//                [self startRemoteGame:bean];
                [self startRemoteGame:dataarr];
            }else{//客户端数据
//                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bean];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataarr];
                [con writeData:con.output WithData:data OperType:SPYGameStartPush];
            }
        }
        indexArr = nil;
        allPlayers = nil;
        newRoles = nil;
        
        self.onGame = YES;
    }
}

-(void)startRemoteGame:(NSArray*)bean{
    GamePlayingViewController *gpvc = [[GamePlayingViewController alloc] initWithNibName:@"GamePlayingViewController" bundle:[NSBundle mainBundle]];
    NSNumber *totalNum = [[NSNumber alloc]initWithInteger:self.totalNum];
    NSNumber *citizenNum = [[NSNumber alloc]initWithInteger:self.citizenNum];
    NSNumber *spyNum = [[NSNumber alloc]initWithInteger:self.spyNum];
    NSNumber *whiteNum = [[NSNumber alloc]initWithInteger:self.whiteBoardNum];
    NSArray *arr = [NSArray arrayWithObjects:totalNum, citizenNum, spyNum, whiteNum, nil];
    [self.mainPlayer setConnection:self.connection];
    [self.mainPlayer setWord:bean[0]];
    [self.mainPlayer setRole:[bean[1] intValue]];
    [gpvc setUpFrame:self.mainPlayer WithOthers:self.subRoomView.allPlayer WithGameInfo:arr AsServer:self.asServer];
    self.clientAlive = YES;
    
    [self presentViewController:gpvc animated:YES completion:nil];

//    [self.view.window.rootViewController presentViewController:gpvc animated:YES completion:nil];

}

-(void)killPlayerWithArr:(NSArray*)arr{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"killPlayer" object:arr];
}

-(void)victory:(NSNumber*)type{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"victory" object:type];
}

-(void)gameOver{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameover" object:nil];
}

-(void)clientLeave:(NSNumber*)index{
    if (index) {
        [self.subRoomView.allPlayer removeObjectAtIndex:[index integerValue]];
        [self.subRoomView.collectionView reloadData];
        [self updateOnlinePlayer];
        if ([index integerValue]>0&&[index integerValue]<=[self.connections count]) {
            [self.connections removeObjectAtIndex:[index integerValue]-1];//因为connections比allplayer少一个（不包含第一个自己的链接）
        }
        //向其余客户端发送消息
        if([self.subRoomView.allPlayer count]>1&&self.asServer){
            for (int i=0; i<[self.connections count]; i++) {
//                NSLog(@"%d-----------%d", (int)[self.subRoomView.allPlayer count], (int)[self.connections count]);
                SPYConnection *con = self.connections[i];
                if (con) {
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:index];
                    [con writeData:con.output WithData:data OperType:SYPClientLeavePush];
                }
            }
        }
    }
}

- (void)statusReady:(NSNumber *)index{
    if (index) {
        PlayerBean *bean = [self.subRoomView.allPlayer objectAtIndex:[index integerValue]];
        bean.status = BLE_ONLINE;
        [self.subRoomView.collectionView reloadData];
        self.readyCount++;
        [self updateOnlinePlayer];
    }
}

-(void)confirmPlayerNumber:(NSNumber*)allCount{
    NSInteger count = [allCount integerValue];
    if (count!=[self.subRoomView.allPlayer count]) {//说明客户端获得数据不正确,需要从新发送所有数据
        //当前在线用户
        NSMutableArray *arr = self.subRoomView.allPlayer;
        NSNumber *num = [[NSNumber alloc]initWithInteger:[self.subRoomView.allPlayer count]];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:num, @"count", arr, @"players", nil];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        SPYConnection *conn = ((SPYConnection*)[self.connections lastObject]);
        [conn writeData:conn.output WithData:data OperType:SPYNewPlayerConfirmPush];
    }
}

-(void)validatePlayerList:(NSMutableArray*)list Number:(NSNumber*)number{
    if ([list count]==[number integerValue]) {//说明验证成功
        self.subRoomView.allPlayer = list;
        [self.subRoomView.collectionView reloadData];
        [self updateOnlinePlayer];
    }else{//验证不成功，客户端退出
        NSNumber *num = self.mainPlayer.index;
        if (self.connection) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:num];
            [self.connection writeData:self.connection.output WithData:data OperType:SYPClientLeavePush];
            [self.connection closeConnection];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end
