//
//  PlayerInfoViewController.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerInfoViewController.h"
#import "AppDelegate.h"

@interface PlayerInfoViewController ()

@end

@implementation PlayerInfoViewController
@synthesize mainPlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = kMAIN_SCREEN_WIDTH;
    CGFloat height = kMAIN_SCREEN_HEIGHT;
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height+20;
    
    CGFloat currentY = barHeight;
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"PlayerHeader" owner:self.view options:nil] lastObject];
    self.header.frame = CGRectMake(0, currentY, width, self.header.frame.size.height);
    [self.header initWithPlayerBean:self.mainPlayer];
    [self.view addSubview:self.header];
    
    currentY += self.header.frame.size.height;
    
    ActionView *actionView = [[ActionView alloc] init];
    [actionView setUpFrame:CGRectMake(0, currentY, width, height-barHeight-self.header.frame.size.height)];
    actionView.delegate = self;
    [self.view addSubview:actionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) createServer{
    NSLog(@"create server. . . ");
}

- (void) asClient{
    NSLog(@"as client. . . ");
}

@end
