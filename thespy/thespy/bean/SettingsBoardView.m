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
        CGFloat cameraTransformX = 0.5;
        CGFloat cameraTransformY = 0.35;
        _camera.cameraViewTransform = CGAffineTransformScale(_camera.cameraViewTransform, cameraTransformX, cameraTransformY);
        //            camera.cameraViewTransform = CGAffineTransformMakeTranslation(-10, -10);
        _camera.showsCameraControls = NO;
        
        //此处设置只能使用相机，禁止使用视频功能
        _camera.mediaTypes = @[(NSString*)kUTTypeImage];
        
        SettingsView *sv = [[SettingsView alloc] initWithFrame:CGRectMake(0, 0, kMAIN_SCREEN_WIDTH, kMAIN_SCREEN_HEIGHT)];
        [sv addSavePhotoDelegate:self];
        _camera.cameraOverlayView = sv;
        
    } else {
        NSLog(@"相机功能不可用");
        return;
    }
}

//点击相册中的图片或照相机照完后点击use后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.delegate dismissViewController];
}

- (void) savePhoto{
    [_camera takePicture];
}

@end
