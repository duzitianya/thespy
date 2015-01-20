//
//  ActionView.h
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionViewDelegate <NSObject>

@optional
- (void) createServer;
- (void) asClient;

@end

@interface ActionView : UIView

@property (nonatomic, weak) id<ActionViewDelegate> delegate;

- (void)setUpFrame:(CGRect)frame;

@end
