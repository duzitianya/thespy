//
//  GameRoomView.m
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameRoomView.h"
#import "SPYFileUtil.h"

@implementation GameRoomView
@synthesize subRoomView;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (!self.asServer) {//如果是客户端，则弹出连接列表
        self.plvc = [[ServerListViewController alloc] init];
        self.plvc.title = @"游戏列表";
        self.plvc.delegate = self;
        
//        [self.navigationController pushViewController:self.plvc animated:NO];
        [self presentViewController:self.plvc animated:NO completion:nil];
    }
    
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat currentY = barHeight + 20;
    
    self.subRoomView = [[GameRoomSubview alloc] initWithNibName:@"GameRoomSubview" bundle:[NSBundle mainBundle]];
    self.subRoomView.view.frame = CGRectMake(0, currentY, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT-currentY);
    [self.subRoomView setMainPlayer:self.mainPlayer];
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
}

- (void) reloadClientListTable:(PlayerBean*)player{
    [self.subRoomView.allPlayer addObject:player];
    [self.subRoomView.collectionView reloadData];
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
    NSInteger port = [sender port];
    NSString *hostname = [sender hostName];
    NSString *type = [sender type];
    NSLog(@"from SPYService-->hostname:%@,  port:%d,  type:%@", hostname, (int)port, type);
    
    SPYConnection *connection = [[SPYConnection alloc] initWithInput:inputStream output:outputStream delegate:self];
    if (![self.connections containsObject:connection]) {
        [self.connections addObject:connection];
    }
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

//解析成功
- (void)netServiceDidResolveAddress:(NSNetService *)server{
    self.service = server;
    
    NSInteger port = [server port];
    NSString *hostname = [server hostName];
    NSString *type = [server type];
    NSLog(@"host:%@,  port:%d,  type:%@", hostname, (int)port, type);
    
    //解析成功后连接服务器
    NSInputStream *inputs;
    NSOutputStream *outputs;
    
    [NSStream getStreamsToHostNamed:hostname port:port inputStream:&inputs outputStream:&outputs];
    self.connection = [[SPYConnection alloc]initWithInput:inputs output:outputs delegate:self];

}

//连接到选定的服务器
- (void)connectToServer:(NSNetService*)service{
    self.service = service;
    self.service.delegate = self;
    [self.service resolveWithTimeout:10];
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
        case NSStreamEventNone:
            break;
        case NSStreamEventOpenCompleted:
            self.streamOpenCount++;
            if (self.streamOpenCount==2&&self.asServer==NO) {//说明输入输出流都已经开启完毕
                //发送本机数据
                UIImage *img = [[SPYFileUtil shareInstance]getUserHeader];//头像数据
                NSString *name = [[SPYFileUtil shareInstance]getUserName];//用户名
                NSString *deviceName = [UIDevice currentDevice].name;
                NSArray *arr = [NSArray arrayWithObjects:UIImagePNGRepresentation(img), name, deviceName, nil];
                NSData *sendData = [NSKeyedArchiver archivedDataWithRootObject:arr];
                NSInteger length = [self.connection writeData:sendData];
                if (length==sizeof(sendData)) {
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
                
            }
            break;
        case NSStreamEventHasBytesAvailable://读取数据
            if ([aStream isKindOfClass:[NSInputStream class]]) {
                NSInputStream *in = (NSInputStream*)aStream;
                NSData *data;
                if (self.asServer) {
                    data = [(SPYConnection*)[self.connections firstObject] readGameDataWithInput:in];
                }else{
                    data = [self.connection readGameDataWithInput:in];
                }
                if (data!=nil&&[data length]>0) {
                    NSArray *arrs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if ([arrs count]==3) {
                        NSData *imgData = arrs[0];
                        NSString *name = arrs[1];
                        NSString *deviceName = arrs[2];
                        
                        UIImage *img = [UIImage imageWithData:imgData];
                        PlayerBean *player = [PlayerBean initWithData:img Name:name DeviceName:deviceName];
                        [self reloadClientListTable:player];
                    }
                }
            }
            break;
        case NSStreamEventErrorOccurred:{
            //出错的时候
            NSError *error = [aStream streamError];
            if (error != NULL){
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle: [error localizedDescription]
                                           message: [error localizedFailureReason]
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                [errorAlert show];
            }
            break;
        }
        case NSStreamEventEndEncountered:
            NSLog(@"####################NSStreamEventEndEncountered###################");
            break;
        default:
            break;
    }
}

@end
