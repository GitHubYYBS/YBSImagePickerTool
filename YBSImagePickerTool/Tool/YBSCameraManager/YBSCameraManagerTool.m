//
//  YBSCameraManagerTool.m
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/4/26.
//  Copyright © 2018年 严兵胜. All rights reserved.
//

#import "YBSCameraManagerTool.h"
#import "UIView+YBSFrame.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "TZImagePickerController.h"
#import "TZImageManager.h"

#import "YBSCameraManager.h"

/** 弱引用 */
#define YBSWeakSelf __weak typeof(self) weakSelf = self;

@interface YBSCameraManagerTool ()

@property (nonatomic, strong) YBSCameraManager *manager;
@property (nonatomic, weak) UIView *pickView;

@end

@implementation YBSCameraManagerTool

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setCameraManagerToolView];
    
}

- (void)setCameraManagerToolView{
    
    BOOL isPhoneX = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO);
    
    // 消失按钮
    UIButton *dimisBtn = [[UIButton alloc] init];
    [dimisBtn setImage:[UIImage imageNamed:@"recall"] forState:UIControlStateNormal];
    [dimisBtn sizeToFit];
    [dimisBtn addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    dimisBtn.ybs_right = YBSSCREEN_WIDTH - 24;
    dimisBtn.ybs_top = kYBSStatusH;
    [self.view addSubview:dimisBtn];
    
    YBSWeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf takePhoto];
    });
    
    
    // 拍照按钮
    UIButton *takePickerBtn = [[UIButton alloc] init];
    takePickerBtn.ybs_size = CGSizeMake(50, 50);
    takePickerBtn.ybs_centerX = self.view.ybs_centerX;
    takePickerBtn.ybs_bottom = YBSSCREEN_HEIGHT - ((isPhoneX)? 34 : 0) - 50;
    [takePickerBtn addTarget:self action:@selector(clickTakePickerBtn) forControlEvents:UIControlEventTouchUpInside];
    takePickerBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:takePickerBtn];

}


#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    NSLog(@"photos = %@  assets = %@",photos,assets);
    
    
}





#pragma mark - Click Action - 点击活动

- (void)takePhoto{
    
    UIView *pickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBSSCREEN_WIDTH, YBSSCREEN_HEIGHT)];
    [self.view insertSubview:_pickView = pickView atIndex:0];
    // 传入View的frame 就是摄像的范围
    _manager = [[YBSCameraManager alloc] initWithParentView:pickView];
    
}

// 点击了拍照按钮
- (void)clickTakePickerBtn{
    
    [self.manager takePhotoWithImageBlock:^(UIImage *originImage, UIImage *scaledImage, UIImage *croppedImage) {
        NSLog(@"originImage = %@___scaledImage = %@___croppedImage = %@",originImage,scaledImage,croppedImage);
    }];
}


// 消失
- (void)dismissViewController{
    
    YBSWeakSelf
    [self dismissViewControllerAnimated:true completion:^{
        weakSelf.manager = nil;
        [weakSelf.pickView removeFromSuperview];
    }];
}


- (void)dealloc{
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
