//
//  PlayerListViewController.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerListViewController.h"

@interface PlayerListViewController ()

@end

@implementation PlayerListViewController
@synthesize playerList ;

- (void)awakeFromNib{
    
}

-(instancetype)init:(NSInteger)totalNum SpyNum:(NSInteger)spyNum CitizenNum:(NSInteger)citizenNum WhiteboardNum:(NSInteger)whiteboardNum{
    
    self = [super init];
    if (self) {
        self.totalNum = totalNum;
        self.spyNum = spyNum;
        self.citizenNum = citizenNum;
        self.whiteBoardNum = whiteboardNum;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isServer) {
        self.server = [SPYService shareInstance];
        self.server.delegate = self;
        if (!self.server.isServerOpen) {
            [self.server publishServer];
        }
    }else{
        self.serverBrowser = [SPYServiceBrowser shareInstance];
        self.serverBrowser.delegate = self;
        [self.serverBrowser browseService];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isServer) {
        return [self.server.clients count];
    }else{
        return [self.serverBrowser.servers count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *key = @"browserCell";
    
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:key forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
    }*/
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (self.isServer) {
        NSNetServiceBrowser *browser = self.server.clients[indexPath.row];
        if (browser) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", browser.description];
        }
    }else{
        NSNetService *service = self.serverBrowser.servers[indexPath.row];
        if (service) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", service.name];
        }
    }
    
    return cell;
}

- (void) reloadClientListTable{
    [self.tableView reloadData];
}

- (void) reloadServerListTable{
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isServer) {
        [self.serverBrowser connectNSServer:indexPath.row];
    }
}

@end
