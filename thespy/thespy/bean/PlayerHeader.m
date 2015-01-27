//
//  PlayerHeader.m
//  thespy
//
//  Created by zhaoquan on 15/1/20.
//  Copyright (c) 2015年 zhaoquan. All rights reserved.
//

#import "PlayerHeader.h"

@implementation PlayerHeader{
    NSDictionary *imgInfo;
}

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
    [self.changeButton setAlpha:0.1];
    [self insertSubview:self.changeButton aboveSubview:_headImg];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(15, self.frame.size.height, kMAIN_SCREEN_WIDTH-30, 1);
    lineLayer.contentsGravity = kCAGravityResizeAspect;
    [lineLayer setBackgroundColor:[UIColorFromRGB(0xdfe0df) CGColor]];
    [self.layer addSublayer:lineLayer];
}

- (void) initWithPlayerBean:(PlayerBean *)bean Delegate:(id<TopViewDelegate>)delegate{
//    NSURL *imageUrl = [NSURL URLWithString:bean.img];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
//    _headImg.image = image;
    _nickName.text = bean.name;
    _deviceName.text = bean.deviceName;
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
        camera.allowsEditing = YES;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            camera.sourceType = UIImagePickerControllerSourceTypeCamera;
            camera.cameraDevice = UIImagePickerControllerCameraDeviceFront;//前置摄像头
//            camera.cameraViewTransform = CGAffineTransformMakeScale(0.5, 0.5);//x,y轴缩放比例
            CGFloat cameraTransformX = 0.5;
            CGFloat cameraTransformY = 0.35;
            camera.cameraViewTransform = CGAffineTransformScale(camera.cameraViewTransform, cameraTransformX, cameraTransformY);
            camera.cameraViewTransform = CGAffineTransformMakeTranslation(-10, -10);
            camera.showsCameraControls = NO;
            
            
            //此处设置只能使用相机，禁止使用视频功能
            camera.mediaTypes = @[(NSString*)kUTTypeImage];
            
//            SettingsView *sv = [[[NSBundle mainBundle] loadNibNamed:@"SettingsView" owner:self options:nil] lastObject];
            SettingsView *sv = [[SettingsView alloc] init];
            camera.cameraOverlayView = sv;
            [camera.view sendSubviewToBack:sv];
            
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
            picker.mediaTypes = @[(NSString*)kUTTypeImage];
        }
        [self.delegate presentViewController:picker];
    } else if(buttonIndex == 2) {
        //取消
    }
}

//点击相册中的图片或照相机照完后点击use后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    imgInfo = info;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认使用该照片吗" message:@"" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"不使用", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        UIImage *img = [imgInfo objectForKey:UIImagePickerControllerOriginalImage];
        _headImg.image = img;
    }
    
    [self.delegate dismissViewController];
}


@end
