//
//  UIImage+category.m
//  thespy
//
//  Created by zhaoquan on 15/1/28.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "UIImage+category.h"

@implementation UIImage (category)

- (UIImage *) scaleFromImage:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
//        CGSize oldsize = image.size;
        CGRect rect = CGRectMake(0, 0, asize.width, asize.height);
//        if (asize.width/asize.height > oldsize.width/oldsize.height) {
//            rect.size.width = asize.height*oldsize.width/oldsize.height;
//            rect.size.height = asize.height;
//            rect.origin.x = (asize.width - rect.size.width)/2;
//            rect.origin.y = 0;
//        }
//        else{
//            rect.size.width = asize.width;
//            rect.size.height = asize.width*oldsize.height/oldsize.width;
//            rect.origin.x = 0;
//            rect.origin.y = (asize.height - rect.size.height)/2;
//        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end
