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

@implementation GameRoomView
@synthesize subRoomView;

- (void)viewDidAppear:(BOOL)animated{
    
    if (!self.asServer&&!self.isRemoteInit) {//如果是客户端，则弹出连接列表
        self.plvc = [[ServerListViewController alloc] init];
        self.plvc.title = @"游戏列表";
        self.plvc.delegate = self;
        
//        [self presentModalViewController:self.plvc animated:NO];
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
        //开始显示Loading动画
        [self.indicator startAnimating];
    }
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
    self.step = 1;
    self.mdata = [[NSMutableData alloc]init];
}


#pragma NetWorkingDelegate
-(void)dismissViewController{//取消连接列表
//    [self dismissModalViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) reloadClientListTable:(NSArray*)list{//刷新用户列表
    [self.subRoomView.allPlayer addObjectsFromArray:list];
    [self.subRoomView.collectionView reloadData];
    [self updateOnlinePlayer];
    if (!self.asServer&&[self.indicator isAnimating]) {
        [self.indicator stopAnimating];
    }
    if (self.asServer) {
        //向新注册用户写回当前在线用户数据
        //发送操作类型标记
        NSMutableArray *arr = self.subRoomView.allPlayer;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
        [[SPYConnection alloc]writeData:((SPYConnection*)[self.connections lastObject]).output WithData:data OperType:SPYAllPlayerPush];
        
        //写房间数据
        NSString *total = [NSString stringWithFormat:@"%d", (int)self.totalNum];
        NSString *citizen = [NSString stringWithFormat:@"%d", (int)self.citizenNum];
        NSString *spy = [NSString stringWithFormat:@"%d", (int)self.spyNum];
        NSString *white = [NSString stringWithFormat:@"%d", (int)self.whiteBoardNum];
        NSArray *roomarr = [NSArray arrayWithObjects:total, citizen, spy, white, nil];
        NSData *roomdata = [NSKeyedArchiver archivedDataWithRootObject:roomarr];
        [[SPYConnection alloc]writeData:((SPYConnection*)[self.connections lastObject]).output WithData:roomdata OperType:SPYGameRoomInfoPush];
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
            self.service = [[NSNetService alloc] initWithDomain:@"local." type:@"_thespy._tcp." name:[NSString stringWithFormat:@"%@-->创建的游戏",deviceName]];
            self.service.includesPeerToPeer = NO;
            [self.service setDelegate:self];
            [self.service scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [self.service publishWithOptions:NSNetServiceListenForConnections];
        }
    }
}

- (void) updateOnlinePlayer{
    self.gameRoomHeader.currentLabel.text = [NSString stringWithFormat:@"%d", (int)[self.subRoomView.allPlayer count]];
}

- (void)closeCurrentGame{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确认要终止游戏吗？" message:@"" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"终止", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self closeService];
        [self.connection closeConnection];
        self.connections = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)addSPYConnection:(SPYConnection *)conn{
    [self.connections addObject:conn];
}

- (void) closeService{
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
                UIImage *img = [[SPYFileUtil shareInstance]getUserHeader];
                NSString *nick = [[SPYFileUtil shareInstance]getUserName];
                NSString *device = [UIDevice currentDevice].name;
                PlayerBean *bean = [PlayerBean initWithData:img Name:nick DeviceName:device];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bean];
                
                [[SPYConnection alloc]writeData:(NSOutputStream*)aStream WithData:data OperType:SPYNewPlayerPush];
                self.isRemoteInit = YES;
                [self dismissModalViewControllerAnimated:NO];
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
                }
                if ([self.mdata length]>4&&self.remainingToRead<=0) {//当读取的数据大于4字节后，读取数据包长度数据
                    uint8_t buf[4];
                    [self.mdata getBytes:buf range:NSMakeRange(0, 4)];
                    self.remainingToRead = ((buf[0]<<24)&0xff000000)+((buf[1]<<16)&0xff0000)+((buf[2]<<8)&0xff00)+(buf[3] & 0xff);
                }
                if ([self.mdata length]>=self.remainingToRead) {//说明数据已经读取完毕
                    uint8_t buf[1];
                    [self.mdata getBytes:buf range:NSMakeRange(4, 1)];
                    int oper = buf[0]&0xff;
                    NSData *data = [self.mdata subdataWithRange:NSMakeRange(5, self.remainingToRead-5)];
                    [[SPYConnection alloc]operation:oper WithData:data Delegate:self];
                    
                    NSData *subs = [self.mdata subdataWithRange:NSMakeRange(self.remainingToRead, [self.mdata length])];
                    if ([subs length]>0) {
                        self.mdata = [NSMutableData dataWithData:subs];
                    }
                    self.remainingToRead = 0;
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
    
    self.totalNum = [total integerValue];
    self.citizenNum = [citizen integerValue];
    self.spyNum = [spy integerValue];
    self.whiteBoardNum = [white integerValue];
    
    self.gameRoomHeader.totalLabel.text = total;
    self.gameRoomHeader.citizenLabel.text = citizen;
    self.gameRoomHeader.spyLabel.text = spy;
    self.gameRoomHeader.whiteboardLabel.text = white;
    
}

@end
