//
//  ServerListViewController.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServerListViewControllerDelegate <NSObject>

@optional
- (void)connectToServer:(NSNetService*)service;

@end

@interface ServerListViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *servers;//NSNetService
@property (nonatomic, strong) NSNetServiceBrowser *browser;

@property (nonatomic, strong) UIViewController *backvc;

@property (nonatomic, weak) id<ServerListViewControllerDelegate, NSNetServiceBrowserDelegate> delegate;

@end
