//
//  PlayerHeader.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerHeader.h"

@implementation PlayerHeader

- (void)awakeFromNib{
    _headImg.layer.borderWidth = 1;
    _headImg.layer.borderColor = [[UIColor greenColor] CGColor];
//    masksToBounds防止子元素溢出父视图。
//    如果一个正方形要设置成圆形，代码为:
    _headImg.layer.cornerRadius = _headImg.frame.size.height/2;
    _headImg.layer.masksToBounds = YES;
    
    CGFloat height = _headImg.frame.size.height;
    CGFloat width = _headImg.frame.size.width;
    CGFloat x = _headImg.frame.origin.x;
    CGFloat y = _headImg.frame.origin.y;
    self.changeButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.changeButton addTarget:self action:@selector(changeHeadImg:) forControlEvents:UIControlEventTouchUpInside];
    self.changeButton.layer.cornerRadius = _headImg.layer.cornerRadius;
    self.changeButton.layer.backgroundColor = [[UIColor blackColor] CGColor];
    [self.changeButton setAlpha:0.5];
    [self insertSubview:self.changeButton aboveSubview:_headImg];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(15, 140, kMAIN_SCREEN_WIDTH-30, 0.5);
    lineLayer.contentsGravity = kCAGravityResizeAspect;
    [lineLayer setBackgroundColor:[UIColorFromRGB(0xdfe0df) CGColor]];
//    [self.layer addSublayer:lineLayer];
}

- (void) initWithPlayerBean:(PlayerBean *)bean Delegate:(id<TopViewDelegate>)delegate{
//    NSURL *imageUrl = [NSURL URLWithString:bean.img];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
//    _headImg.image = image;
    _name.text = bean.name;
    _playerID.text = bean.id;
    [_historyButton addTarget:self action:@selector(historyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _delegate = delegate;
}

- (void)changeHeadImg:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从手机相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self];
}


- (void) historyButtonClick:(id)sender{
    [self.delegate gotoHistoryList];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController *camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
        camera.allowsEditing = NO;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            camera.sourceType = UIImagePickerControllerSourceTypeCamera;
            //此处设置只能使用相机，禁止使用视频功能
//            camera.mediaTypes = [[NSArray alloc]initWithObjects:@"kUTTypeImage",nil];
        } else {
            NSLog(@"相机功能不可用");
            return;
        }
        [self.delegate presentViewController:camera];
    } else if (buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        //从相册列表选取
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            //此处设置只能使用相机，禁止使用视频功能
//            picker.mediaTypes = [[NSArray alloc]initWithObjects:@"kUTTypeImage",nil];
        }
        [self.delegate presentViewController:picker];
    } else if(buttonIndex == 2) {
        //取消
    }
}

//点击相册中的图片或照相机照完后点击use后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"=====================");
    self.imgUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认使用该照片吗" message:@"" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"不使用", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imgUrl]];
        _headImg.image = image;
    }
    
    [self.delegate dismissViewController];
}

@end
