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
        _camera.cameraViewTransform = CGAffineTransformTranslate(_camera.cameraViewTransform, 0, -150);
        _camera.showsCameraControls = NO;
        
        //此处设置只能使用相机，禁止使用视频功能
        _camera.mediaTypes = @[(NSString*)kUTTypeImage];
        
        _settingsview = [[SettingsView alloc] initWithFrame:CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT)];
        [_settingsview addSavePhotoDelegate:self];
        _camera.cameraOverlayView = _settingsview;
        
    } else {
        NSLog(@"相机功能不可用");
        return;
    }
}

//点击相册中的图片或照相机照完后点击use后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if (_settingsview.subview.nickName==nil||[_settingsview.subview.nickName length]==0) {
        
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
    
    img = [img scaleFromImage:img toSize:CGSizeMake(150, 150)];
//    img = [img thumbnailWithImageWithoutScale:img size:CGSizeMake(150, 150)];
    [[SPYFileUtil shareInstance] saveUserHeader:img];
    [[SPYFileUtil shareInstance] saveUserName:_settingsview.subview.nickName];
    
    [self.delegate dismissViewController];
}

- (void) savePhoto{
    [_camera takePicture];
}

@end
