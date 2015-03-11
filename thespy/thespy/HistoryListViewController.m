//
//  HistoryListViewControllerTableViewController.m
//  thespy
//
//  Created by zhaoquan on 15/1/21.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "HistoryListViewController.h"
#import "UIWindow+YzdHUD.h"

@interface HistoryListViewController ()

@end

@implementation HistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[GameDB shareInstance] historyList];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearGameHistory)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GameResult *r = [self.data objectAtIndex:indexPath.row]; 
    
    static NSString *CellIdentifier = @"historyCell";
    HistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HistoryListCell" owner:self options:nil] objectAtIndex:0];
        UINib *nib = [UINib nibWithNibName:@"HistoryListCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];//注册cell复用
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell initWithGameResult:r Index:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)clearGameHistory{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清空记录" message:@"确认要清空游戏记录吗？" delegate:self cancelButtonTitle:@"不清空" otherButtonTitles:@"清空", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        BOOL isSuccess = [[GameDB shareInstance]clearAllResult];
        if (isSuccess) {
            [self.view.window showHUDWithText:@"清除成功" Type:ShowPhotoYes Enabled:YES];
            self.data = [[GameDB shareInstance] historyList];
            [self.tableView reloadData];
        }
    }
}

@end
