//
//  ServerListViewController.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "ServerListViewController.h"

@implementation ServerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.servers = [[NSMutableArray alloc] initWithCapacity:5];
    [self browseService];
    
    UIImage *image = [UIImage imageNamed:@"SpyResource.bundle/left_icon"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:@selector(closeCurrentGame)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.servers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSNetService *service = self.servers[indexPath.row];
    if (service) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", service.name];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNetService *service = [self.servers objectAtIndex:[indexPath row]];
    [self.delegate connectToServer:service];
}

- (void) browseService{
    self.browser.delegate = nil;
    self.browser = nil;
    [self.browser removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.browser stop];
    
    self.browser = [[NSNetServiceBrowser alloc] init];
    self.browser.includesPeerToPeer = YES;
    self.browser.delegate = self.delegate;
    [self.browser scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.browser searchForServicesOfType:@"_thespy._tcp." inDomain:@"local"];
}

- (void)closeCurrentGame{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
