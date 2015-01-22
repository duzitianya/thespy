//
//  HistoryListViewControllerTableViewController.m
//  thespy
//
//  Created by zhaoquan on 15/1/21.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "HistoryListViewController.h"

@interface HistoryListViewController ()

@end

@implementation HistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[GameDB shareInstance] historyList];
    
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


@end
