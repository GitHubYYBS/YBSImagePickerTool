//
//  YBSImagePickerTool.m
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/4/25.
//  Copyright © 2018年 严兵胜. All rights reserved.
//

#import "YBSImagePickerTool.h"
#import "YBSHeader.h"
#import "YBSBobbleTool.h"

#import "UIViewController+TopViewController.h"
#import "YBSlertActionStyleSheet.h"

#import "TZImagePickerController.h"
#import "TZImageManager.h"

#import "YBSFullScreeTakeImageTool.h"




typedef NS_ENUM(NSInteger,YBSAuthorizationCameraOrPhotoType){
    /// @brief 相机
    YBSAuthorizationCameraOrPhotoTypeForCamera = 0,
    /// @brief 相册
    YBSAuthorizationCameraOrPhotoTypeForPhoto = 1,
};

@interface YBSImagePickerTool ()<YBSlertActionStyleSheetDalegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, assign,getter=isSuccess) BOOL success;
@property (nonatomic, assign) NSInteger maxImagesCount; // 访问相册时  最多可以选择几张图片 默认最多一次选择9张

@property (nonatomic, copy) void(^finishPickingPhotosBlock)(NSArray *finishPickingPhotosArry); // 获取到照片
@property (nonatomic, copy) void(^failureBlock)(NSString *errorStr); // 失败回到

@property (nonatomic, assign)YBSAuthorizationCameraOrPhotoType  authorizationType;

@end


#define kNavigationBarBarTintColor [UIColor whiteColor] // 导航栏背景色
#define kNavigationBarTintColor [UIColor blackColor] // 字体颜色



static YBSImagePickerTool *imagePickerTool;

static NSString *const fromPhoto = @"从相册中获取";
static NSString *const take_a_picture = @"拍照";
static CGFloat const ybs_cropRect_WH = 300; // 默认裁剪框的尺寸

@implementation YBSImagePickerTool

- (instancetype)init{
    
    if ((imagePickerTool = [super init])) {
        
        imagePickerTool.maxImagesCount = 9;
        imagePickerTool.ybs_allowPickingVideo = false;
        imagePickerTool.ybs_allowCrop = true;
        imagePickerTool.ybs_cropRect = CGRectMake(SCREEN_WIDTH * 0.5 - ybs_cropRect_WH * 0.5, SCREEN_HEIGHT * 0.5 - ybs_cropRect_WH * 0.5, ybs_cropRect_WH, ybs_cropRect_WH);
        imagePickerTool.ybs_needCircleCrop = false;
        imagePickerTool.ybs_needCircleCrop = false;
        imagePickerTool.ybs_allowCropTake_a_picture = false;
        imagePickerTool.ybs_circleCropRadius = ybs_cropRect_WH * 0.5;
    }
    
    return imagePickerTool;
}

/*
 有底部选项卡 弹出
 */

+ (void)ybs_ImagePickerToolWithMaxImagesCount:(NSInteger)maxImagesCount didFinishPickingPhotos:(void (^)(NSArray *))finishPickingPhotos failure:(void (^)(NSString *))failure{
    
    if (imagePickerTool == nil) {
        imagePickerTool = [[self alloc] init];
        
    }
    if (finishPickingPhotos) imagePickerTool.finishPickingPhotosBlock = finishPickingPhotos;
    if (failure) imagePickerTool.failureBlock = failure;
    imagePickerTool.maxImagesCount = maxImagesCount;
    [YBSlertActionStyleSheet ybs_AlertActionStyleSheetDelegate:imagePickerTool titileStr:nil message:nil otherTitles:fromPhoto,take_a_picture, nil];
}

- (void)ybs_ImagePickerToolWithMaxImagesCount:(NSInteger)maxImagesCount didFinishPickingPhotos:(void (^)(NSArray *))finishPickingPhotos failure:(void (^)(NSString *))failure{
    
    if (imagePickerTool == nil) {
        imagePickerTool = [[YBSImagePickerTool alloc] init];
        
    }
    
    if (finishPickingPhotos) imagePickerTool.finishPickingPhotosBlock = finishPickingPhotos;
    if (failure) imagePickerTool.failureBlock = failure;
    
    imagePickerTool.maxImagesCount = maxImagesCount;
    [YBSlertActionStyleSheet ybs_AlertActionStyleSheetDelegate:imagePickerTool titileStr:nil message:nil otherTitles:fromPhoto,take_a_picture, nil];
}

/*
 直接 从_相机_单独拿图片
 */


+ (void)ybs_getImageFromeCameraDidFinishPickingPhotos:(void(^)(NSArray *imagesArray))finishPickingPhotos failure:(void(^)(NSString *errorStr))failure{
    
    if (imagePickerTool == nil) {
        imagePickerTool = [[self alloc] init];
        
    }
    
    if (finishPickingPhotos) imagePickerTool.finishPickingPhotosBlock = finishPickingPhotos;
    if (failure) imagePickerTool.failureBlock = failure;
    imagePickerTool.maxImagesCount = 1;
    
    [imagePickerTool ybs_getImageFromeCamere];
}

- (void)ybs_getImageFromeCameraDidFinishPickingPhotos:(void(^)(NSArray *imagesArray))finishPickingPhotos failure:(void(^)(NSString *errorStr))failure{
    
    if (imagePickerTool == nil) {
        imagePickerTool = [[YBSImagePickerTool alloc] init];
        
    }
    if (finishPickingPhotos) imagePickerTool.finishPickingPhotosBlock = finishPickingPhotos;
    if (failure) imagePickerTool.failureBlock = failure;
    imagePickerTool.maxImagesCount = 1;
    
    [self ybs_getImageFromeCamere];
}

/*
 直接 从相册单独拿图片
 */

+ (void)ybs_getIamageFromePhotoWithMaxImagesCount:(NSInteger )maxImagesCount didFinishPickingPhotos:(void(^)(NSArray *imagesArray))finishPickingPhotos failure:(void(^)(NSString *errorStr))failure{
    
    if (imagePickerTool == nil) {
        imagePickerTool = [[self alloc] init];
        
    }
    
    if (finishPickingPhotos) imagePickerTool.finishPickingPhotosBlock = finishPickingPhotos;
    if (failure) imagePickerTool.failureBlock = failure;
    imagePickerTool.maxImagesCount = maxImagesCount;
    
    [imagePickerTool ybs_getImageFromePhoto];
}

- (void)ybs_getImageFromePhotoWithMaxImagesCount:(NSInteger )maxImagesCount didFinishPickingPhotos:(void(^)(NSArray *imagesArray))finishPickingPhotos failure:(void(^)(NSString *errorStr))failure{
    
    if (imagePickerTool == nil) {
        imagePickerTool = [[YBSImagePickerTool alloc] init];
        
    }
    
    if (finishPickingPhotos) imagePickerTool.finishPickingPhotosBlock = finishPickingPhotos;
    if (failure) imagePickerTool.failureBlock = failure;
    imagePickerTool.maxImagesCount = maxImagesCount;
    
    [self ybs_getImageFromePhoto];
}


#pragma mark - 懒加载

- (UIImagePickerController *)imagePickerVc {
    if (!_imagePickerVc)
    {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = imagePickerTool;
        _imagePickerVc.navigationBar.barTintColor = kNavigationBarBarTintColor;
        _imagePickerVc.navigationBar.tintColor = kNavigationBarTintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9.0, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark - YBSlertActionStyleSheetDalegate

- (void)ybsAlertController:(YBSlertActionStyleSheet *)alertController didClickAlertAction:(UIButton *)alertAction{
    
    if ([alertAction.titleLabel.text isEqualToString:fromPhoto]) {
        // 相册
        [self ybs_getImageFromePhoto];
        
    }else if ([alertAction.titleLabel.text isEqualToString:take_a_picture]){
        // 拍照
        [self ybs_getImageFromeCamere];
    }
    
}

// 从相机
- (void)ybs_getImageFromeCamere{
    
    self.success = false;
    self.authorizationType = YBSAuthorizationCameraOrPhotoTypeForCamera;
    [self takePhoto];
}

// 相册
- (void)ybs_getImageFromePhoto{
    
    self.success = false;
    self.authorizationType = YBSAuthorizationCameraOrPhotoTypeForPhoto;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:imagePickerTool.maxImagesCount delegate:self];
    imagePickerVc.navigationBar.barTintColor = kNavigationBarBarTintColor;
    imagePickerVc.navigationBar.tintColor = kNavigationBarTintColor;
    imagePickerVc.naviTitleColor = kNavigationBarTintColor;
    imagePickerVc.barItemTextColor = kNavigationBarTintColor;
#warning ios8.4 图片发生了旋转__待解决
    imagePickerVc.allowPickingVideo = imagePickerTool.ybs_allowPickingVideo; // 是否可以选择视频
    imagePickerVc.showSelectBtn = false; // 在单选模式下，照片列表页中，显示选择按钮,默认为NO  多选模式下 会被强制为 YES
    imagePickerVc.allowCrop = imagePickerTool.ybs_allowCrop; // 只有在单选模式下才会生效  在多选模式下回强制无效
    imagePickerVc.cropRect = imagePickerTool.ybs_cropRect; // 裁剪尺寸
    imagePickerVc.needCircleCrop = imagePickerTool.ybs_needCircleCrop;
    imagePickerVc.circleCropRadius = imagePickerTool.ybs_circleCropRadius;
    [[UIApplication sharedApplication].keyWindow.rootViewController.ybs_topViewController presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    [imagePickerTool addMoreImages:photos sourceAssets:assets];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (!imagePickerTool.ybs_allowCropTake_a_picture) { // 通过相机获得的图片 是否允许裁剪
            [imagePickerTool addMoreImages:@[image] sourceAssets:nil]; // 很重要必须写
            return;
        }
        
        TZImagePickerController *imagePicVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [YBSBobbleTool showRoundProgressWithTitle:@"...正在压缩..."];
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){ // 保存图片，获取到asset
            if (error)
            {
                [imagePicVc hideProgressHUD];
                [YBSBobbleTool showErrorWithTitle:@"...压缩失败,请重试..."];
                [imagePickerTool failureWithErrorStr:@"压缩失败"];
                return ;
            }
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models){
                    TZAssetModel *assetModel = [models firstObject];
                    if (imagePicVc.sortAscendingByModificationDate) assetModel = [models lastObject];
                    [YBSBobbleTool dismiss];
                    TZImagePickerController *imageCropPicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                        [YBSBobbleTool dismiss];
                        [imagePickerTool addMoreImages:@[cropImage] sourceAssets:@[assetModel.asset]]; // 很重要必须写
                    }];
                    
                    imageCropPicker.cropRect = imagePickerTool.ybs_cropRect; // 裁剪尺寸
                    imageCropPicker.needCircleCrop = imagePickerTool.ybs_needCircleCrop;
                    imageCropPicker.circleCropRadius = imagePickerTool.ybs_circleCropRadius;
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imageCropPicker animated:YES completion:nil];
                }]; }]; }];
    }
}


#pragma mark - Other Action

- (void)takePhoto{
    
    if (![self isCanOpenCamera]) return;
    
    if (self.ybs_fullScreenTakePickerBool){ // 需要全屏拍照
        YBSFullScreeTakeImageTool *vc = [YBSFullScreeTakeImageTool new];
        [vc ybs_fullScreeTakeImageToolidFinishPickingPhotos:^(UIImage *image) {
            if (imagePickerTool.finishPickingPhotosBlock) imagePickerTool.finishPickingPhotosBlock(@[image]);
        } failure:nil];
    }else{
        [[UIApplication sharedApplication].keyWindow.rootViewController.ybs_topViewController presentViewController:self.imagePickerVc animated:YES completion:nil];
    }
}


- (void)addMoreImages:(NSArray*)images sourceAssets:(NSArray *)assets{
    self.success = true;
    if (imagePickerTool.finishPickingPhotosBlock) imagePickerTool.finishPickingPhotosBlock(images);
    imagePickerTool = nil;
}

- (void)failureWithErrorStr:(NSString *)errorStr{
    
    if (imagePickerTool.failureBlock) imagePickerTool.failureBlock(errorStr);
    imagePickerTool = nil;
}



// 调用相机 检查相机权限 (因为拍照之后要保持到本地 所以相册权限也会检测)  api 都是iOS7之后的
- (BOOL)isCanOpenCamera{
    
    // 获取摄像机设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        // 用户从未授权 即将弹窗希望用户授权
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                YBSLog(@"%@",granted? @"用户第一次同意了相机访问" : @"用户第一次拒绝了相机访问")
                if (granted) [self takePhoto];
            }];
        }else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){ // 用户禁止使用,且授权状态不可修改,可能由于家长控制功能 // 用户已经禁止使用
            NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"无权访问相机" message:[NSString stringWithFormat:@"请为\"%@\"打开相机访问权限\n[设置 - 隐私 - 相机]",app_Name] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"前往设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                self.authorizationType = YBSAuthorizationCameraOrPhotoTypeForCamera;
                [self ybs_GoSetting];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:cancelAction];
            [alertC addAction:alertA];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
            
            // 这里省略掉了 检测相册权限的判断 加入我们需要做到 拍摄的照片存到相册里 就要做相册权限的判断
            
        }else{
            
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                self.imagePickerVc.sourceType = sourceType;
                if(iOS8Later) _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                return true;
            } else
            {
                YBSLog(@"模拟器中无法打开照相机,请在真机中使用");
            }
        }
        
    }else{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
    }
    
    return 0;
}


#pragma mark - 额外api  相机权限
+ (void)ybs_cameraPermissionResult:(void (^)(BOOL))resultBlock{
    
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            // 用户第一次进入-弹窗询问权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                dispatch_async(dispatch_get_main_queue(), ^{ // 回到主线程 回调结果  否则会有迟疑
                    if (resultBlock) resultBlock(granted);
                });
                YBSLog(@"%@",granted? @"用户第一次同意了相机访问" : @"用户第一次拒绝了相机访问")
            }];
            
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            
            if (resultBlock) resultBlock(true);
            
            
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            
            NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"无权访问相机" message:[NSString stringWithFormat:@"请为\"%@\"打开相机访问权限\n[设置 - 隐私 - 相机]",app_Name] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
            
            if (resultBlock) resultBlock(false);
            
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
            
            if (resultBlock) resultBlock(false);
            
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
        
        if (resultBlock) resultBlock(false);
        
    }
    
}

+ (void)ybs_PhonePermissionResult:(void (^)(BOOL))resultBlock{
    
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        // 判断授权状态
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
            // 弹框请求用户授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) { // 用户第一次同意了访问相册权限
                    // 跳转图片选择控制器
                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    //                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    //                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
                    //                        imagePicker.delegate = self;
                    //                        [self.currentVC presentViewController:imagePicker animated:YES completion:nil];
                    //                    });
                    
                    if (resultBlock) resultBlock(true);
                    YBSLog(@"用户第一次同意了相册访问")
                    
                } else { // 用户第一次拒绝了访问相机权限
                    YBSLog(@"用户第一次拒绝了相册访问")
                    
                }
            }];
            
        } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
            
            // 跳转到图片选择图片控制器
            //            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            //            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
            //            imagePicker.delegate = self;
            //            [self.currentVC presentViewController:imagePicker animated:YES completion:nil];
            
            if (resultBlock) resultBlock(true);
            
            
        } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
            
            if (resultBlock) resultBlock(false);
            
            NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"无权访问相册" message:[NSString stringWithFormat:@"请为\"%@\"打开相册权限\n[设置 - 隐私 - 照片]",app_Name] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
        } else if (status == PHAuthorizationStatusRestricted) {
            
            if (resultBlock) resultBlock(false);
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于系统原因, 无法访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
        }
    }
    
}



- (void)ybs_GoSetting{
    
    if ((([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }else{
        NSURL *privacyUrl;
        if (self.authorizationType == YBSAuthorizationCameraOrPhotoTypeForPhoto) {
            privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
        } else {
            privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
        }
        if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
            [[UIApplication sharedApplication] openURL:privacyUrl];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请打开设置手动前往" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
}




- (void)dealloc{
    
    YBSLogClassDealloc
}





@end
