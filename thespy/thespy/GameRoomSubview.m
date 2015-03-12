//
//  GameRoomSubview.m
//  thespy
//
//  Created by zhaoquan on 15/1/26.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "GameRoomSubview.h"

@interface GameRoomSubview ()

@end

@implementation GameRoomSubview
@synthesize allPlayer;

static NSString * const reuseIdentifier = @"Cell";

- (void)dealloc{
//    self.allPlayer = nil;
    self.collectionView.delegate = nil;
    NSLog(@"GameRoomSubview dealloc....");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.allPlayer = [[NSMutableArray alloc] initWithCapacity:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setMainPlayer:(PlayerBean*)player{
    [self.allPlayer addObject:player];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.allPlayer count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSArray *subs = [cell.contentView subviews];
    if (subs==nil||[subs count]==0) {//说明第一次初始化
        GameRoomCell *gameRoomCell = [[[NSBundle mainBundle] loadNibNamed:@"GameRoomCell" owner:self options:nil] lastObject];
        PlayerBean *bean = [self.allPlayer objectAtIndex:indexPath.row];
        [gameRoomCell setupWithData:bean];
        gameRoomCell.countLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row+1)];
        [cell.contentView addSubview:gameRoomCell];
    }else{
        if ([subs[0] isKindOfClass:[GameRoomCell class]]) {
            GameRoomCell *gameRoomCell = (GameRoomCell*)subs[0];
            [gameRoomCell setupWithData:[self.allPlayer objectAtIndex:indexPath.row]];
            gameRoomCell.countLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row+1)];
        }
    }

    return cell;
}


@end
