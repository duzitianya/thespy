//
//  ActionView.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol ActionViewDelegate <NSObject>

@optional
- (void) createServer;
- (void) asClient;

@end

@interface ActionView : UIView<CBCentralManagerDelegate>

@property (nonatomic, weak) id<ActionViewDelegate> delegate;
@property (nonatomic) NSInteger tag;
@property (nonatomic, strong) UIButton *server;
@property (nonatomic, strong) UIButton *client;
@property (nonatomic, retain) CBCentralManager *centralManager;

- (void)setUpFrame:(CGRect)frame;

- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

@end
