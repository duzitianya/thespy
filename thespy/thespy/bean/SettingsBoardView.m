//
//  SettingsBoardView.m
//  thespy
//
//  Created by zhaoquan on 15/1/28.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "SettingsBoardView.h"

@implementation SettingsBoardView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void) setupWithDelegate:(id<CameraOpenDelegate>)delegate{
    self.delegate = delegate;
    _camera = [[UIImagePickerController alloc] init];
    _camera.delegate = self;
    _camera.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        _camera.cameraDevice = UIImagePickerControllerCameraDeviceFront;//前置摄像头
        
        CGFloat scale = 150*1.0/kMAIN_SCREEN_WIDTH;
        CGFloat cameraTransformX = scale;
        CGFloat cameraTransformY = scale;
        _camera.cameraViewTransform = CGAffineTransformScale(_camera.cameraViewTransform, cameraTransformX, cameraTransformY);
    
        //计算偏移量
        CGFloat s = (kMAIN_SCREEN_HEIGHT - kMAIN_SCREEN_HEIGHT*scale) / 2;
        _camera.cameraViewTransform = CGAffineTransformTranslate(_camera.cameraViewTransform, 0, -100);
        _camera.showsCameraControls = NO;
        
        //此处设置只能使用相机，禁止使用视频功能
        _camera.mediaTypes = @[(NSString*)kUTTypeImage];
        
        self.cameraOverlayView = [[[NSBundle mainBundle]loadNibNamed:@"CameraOverlayView" owner:self options:nil]lastObject];
        self.cameraOverlayView.delegate = self;
        _camera.cameraOverlayView = self.cameraOverlayView;
        
    } else {
        NSLog(@"相机功能不可用");
        return;
    }
}

//点击相册中的图片或照相机照完后点击use后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    if (self.cameraOverlayView.nickName==nil||[[self.cameraOverlayView.nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写昵称" message:@"" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    UIImage *img;
    if ([info objectForKey:UIImagePickerControllerEditedImage]) {
        img = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        img = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
//    img = [img scaleFromImage:img toSize:CGSizeMake(150, 150)];
    img = [img thumbnailWithImageWithoutScale:img size:CGSizeMake(150, 150)];
    [[SPYFileUtil shareInstance] saveUserHeader:img];
    [[SPYFileUtil shareInstance] saveUserName:self.cameraOverlayView.nickName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHeaderData" object:nil];
    
    [self.delegate dismissViewController];
}

- (void) savePhoto{
    [_camera takePicture];
}

- (void) cancelSave{
    [self.delegate dismissViewController];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void) didBeginEditing:(UITextField *)textField{
    [self moveViews:-100];
}

- (void) didEndEditing:(UITextField *)textField{
    [self moveViews:100];
}

- (void) moveViews:(int)offset{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.cameraOverlayView.frame = CGRectMake(self.cameraOverlayView.frame.origin.x, self.cameraOverlayView.frame.origin.y+offset, self.cameraOverlayView.frame.size.width, self.cameraOverlayView.frame.size.height);
    if (offset>0) {
        _camera.cameraViewTransform = CGAffineTransformTranslate(_camera.cameraViewTransform, 0, 250);
    }else{
        _camera.cameraViewTransform = CGAffineTransformTranslate(_camera.cameraViewTransform, 0, -250);
    }

    [UIView commitAnimations];
}

@end
