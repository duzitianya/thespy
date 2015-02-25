//
//  SPYFileUtil.h
//  thespy
//
//  Created by zhaoquan on 15/1/27.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define APP_PLAYER_DATA_HOME @"/Documents/thespy/playerdata"
#define APP_PLAYER_HEADER @"/Documents/thespy/headerdata"

@interface SPYFileUtil : NSObject

+(SPYFileUtil *)shareInstance;

- (BOOL) isUserDataExist;

- (void) saveUserHeader:(UIImage*)header;

- (void) saveUserName:(NSString*)userName;

- (UIImage*) getUserHeader;

- (NSString*) getUserName;

- (NSArray*) getWords;

//- (void) updateWordsPlayTimes:(NSInteger)index;

@end
