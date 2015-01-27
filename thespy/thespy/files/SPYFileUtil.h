//
//  SPYFileUtil.h
//  thespy
//
//  Created by zhaoquan on 15/1/27.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_PLAYER_DATA_HOME @"/thespy/playerdata"
#define APP_PLAYER_HEADER @"/thespy/headerdata"

@interface SPYFileUtil : NSObject

+(SPYFileUtil *)shareInstance;

- (BOOL) isUserDataExist;

- (void) saveUserHeader:(NSData*)header;

- (void) saveUserName:(NSString*)userName;

- (NSData*) getUserHeader;

- (NSString*) getUserName;

@end
