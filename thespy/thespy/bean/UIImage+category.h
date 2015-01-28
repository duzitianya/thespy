//
//  UIImage+category.h
//  thespy
//
//  Created by zhaoquan on 15/1/28.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (category)

//创建缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

//改变图像尺寸
- (UIImage *) scaleFromImage:(UIImage *)image toSize:(CGSize)size;

@end
