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
//    return [self.allPlayer count];
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell.contentView subviews];
    GameRoomCell *gameRoomCell = [[[NSBundle mainBundle] loadNibNamed:@"GameRoomCell" owner:self options:nil] lastObject];
    //    [gameRoomCell setupWithData:[self.allPlayer objectAtIndex:indexPath.row]];
    [gameRoomCell setupWithData:[self.allPlayer objectAtIndex:0]];
    gameRoomCell.countLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row+1)];
    [cell.contentView addSubview:gameRoomCell];
    
    return cell;
}




@end
