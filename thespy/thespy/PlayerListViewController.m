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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.serverBrowser = [SPYServiceBrowser shareInstance];
    self.serverBrowser.delegate = self;
    [self.serverBrowser browseService];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.serverBrowser.servers count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSNetService *service = self.serverBrowser.servers[indexPath.row];
    if (service) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", service.name];
    }
    
    return cell;
}

- (void) reloadServerListTable{
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.serverBrowser connectNSServer:indexPath.row];
    
//    GameRoomView *room = [[GameRoomView alloc] init];
//    [room setupValues:totalNum SpyNum:spyNum CitizenNum:citizenNum WhiteboardNum:whiteBoardNum MainPlayer:self.mainPlayer asServer:YES];
//    room.title = @"等待开始";
    
//    [self.navigationController pushViewController:room animated:YES];
}

@end
