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
//    
//    HistoryListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryListCell" owner:self options:nil] lastObject];
//    GameResult *r = [self.data objectAtIndex:indexPath.row];
//    [[HistoryListCell alloc] initWithGameResult:r Index:indexPath.row];
    
    GameResult *r = [self.data objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"historyCell";
    HistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HistoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell initWithGameResult:r Index:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
}


@end
