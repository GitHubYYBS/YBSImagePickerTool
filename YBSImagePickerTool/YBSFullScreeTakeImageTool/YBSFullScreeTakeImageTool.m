//
//  YBSFullScreeTakeImageTool.m
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/5/2.
//  Copyright © 2018年 严兵胜. All rights reserved.
//

#import "YBSFullScreeTakeImageTool.h"

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#import "UIViewController+Expand.h"


/**  尺寸 */
#define YBSSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define YBSSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 宽度适配
#define YBSScalingStyle(Value) (Value*YBSSCREEN_WIDTH/750)

/**  获取状态栏高度 */
#define kStatusH  MIN([UIApplication sharedApplication].statusBarFrame.size.height, [UIApplication sharedApplication].statusBarFrame.size.width)

/// 竖屏状态下 扫描框 x 占 屏幕宽度的比例 -> 如果需要调整间距可以将该值进行调整 最大为24
static CGFloat const vertical_X_SCREEN_WIDTH_proportion = 0.064;
/// 拍照按钮大小
static CGFloat const takeImageBtn_WH = 75;



@interface YBSFullScreeTakeImageTool ()

@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic,strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *VPlayer;
@property (nonatomic,strong) AVCaptureDevice *captureDevice;

/// 队列
@property (nonatomic,strong) dispatch_queue_t queue;

@end

@implementation YBSFullScreeTakeImageTool

#pragma mark - init - 初始化

- (void)ybs_fullScreeTakeImageToolidFinishPickingPhotos:(YBSGetImageSuccessBlock)finishPickingPhotosBlock failure:(YBSGetImageFailureBlock)failure{
    
    if (finishPickingPhotosBlock) self.ybs_getImageSuccessBlock = finishPickingPhotosBlock;
    if (failure) self.ybs_getImageFailureBlock = failure;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.ybs_topViewController presentViewController:self animated:YES completion:nil];
}

+ (void)ybs_fullScreeTakeImageToolidFinishPickingPhotos:(YBSGetImageSuccessBlock)finishPickingPhotosBlock failure:(YBSGetImageFailureBlock)failure{
    
    YBSFullScreeTakeImageTool *vc = [YBSFullScreeTakeImageTool new];
    if (finishPickingPhotosBlock) vc.ybs_getImageSuccessBlock = finishPickingPhotosBlock;
    if (failure) vc.ybs_getImageFailureBlock = failure;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.ybs_topViewController presentViewController:vc animated:YES completion:nil];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // YYBS -> 需要检查相机权限 暂时没做 2018.5.2
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setFullScreeTakeImageTool];
    
    [self setUPUI];
    
    [self runSession];
}

// 配置相机相关
- (void)setFullScreeTakeImageTool {
    
    // 获取相机设备
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 创建输入与输出的中间桥梁
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    // 创建输入设备
    self.deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithDirection:AVCaptureDevicePositionBack] error:nil];
    // 创建输出设备
    self.imageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.imageOutput setOutputSettings:outputSettings];
    
    // 为中间桥梁 添加 输入输出设备
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput:self.deviceInput];
    }
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    

    // 创建预览图层
    self.VPlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.VPlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.VPlayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.VPlayer atIndex:0];
}

/// 配置相机相关的UI
- (void)setUPUI{
    // 相机显示窗口
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.3);
    CGContextFillRect(context, self.view.bounds);
    CGContextClearRect(context, [self makeScanReaderInterrestRect]);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imgView.image = image;
    [self.view addSubview:imgView];
    
    // 扫描框
    UIImageView *centerView = [[UIImageView alloc] init];
    //扫描框图片的拉伸，拉伸中间一块区域
    UIImage *scanImage = [UIImage imageNamed:@"YBSFullScreeTakeImageTool.bundle/scanImage@2x"];
    CGFloat top = 34 * 0.5-1; // 顶端盖高度
    CGFloat bottom = top ; // 底端盖高度
    CGFloat left = 34 * 0.5-1; // 左端盖宽度
    CGFloat right = left; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    scanImage = [scanImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    centerView.image = scanImage;
    centerView.contentMode = UIViewContentModeScaleToFill;
    centerView.backgroundColor = [UIColor clearColor];
    centerView.frame = [self makeScanReaderInterrestRect];
    [self.view addSubview:centerView];
    
    
    // 拍照按钮
    UIButton *takeImageBtn = [UIButton new];
    takeImageBtn.backgroundColor = [UIColor clearColor];
    [takeImageBtn setBackgroundImage:[UIImage imageNamed:@"YBSFullScreeTakeImageTool.bundle/takeImageBtn"] forState:UIControlStateNormal];
    takeImageBtn.frame = CGRectMake(YBSSCREEN_WIDTH * 0.5 - takeImageBtn_WH * 0.5, YBSSCREEN_HEIGHT - takeImageBtn_WH - 50, takeImageBtn_WH, takeImageBtn_WH);
    takeImageBtn.layer.cornerRadius = takeImageBtn_WH * 0.5;
    takeImageBtn.layer.masksToBounds = true;
    [takeImageBtn addTarget:self action:@selector(clickTakeImageBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeImageBtn];
    
    // 开灯
    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lightBtn setImage:[UIImage imageNamed:@"YBSFullScreeTakeImageTool.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [lightBtn setImage:[UIImage imageNamed:@"YBSFullScreeTakeImageTool.bundle/qrcode_scan_btn_flash_sel"] forState:UIControlStateSelected];
    [lightBtn addTarget:self action:@selector(clickLightBtn:) forControlEvents:UIControlEventTouchUpInside];
    lightBtn.frame = CGRectMake(0, 0, takeImageBtn_WH * 0.35, takeImageBtn_WH * 0.35);
    lightBtn.center = CGPointMake(CGRectGetMinX(takeImageBtn.frame) * 0.5, takeImageBtn.center.y);
    [self.view addSubview:lightBtn];
    
    // 消失按钮
    UIButton *dimisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dimisBtn setImage:[UIImage imageNamed:@"YBSFullScreeTakeImageTool.bundle/recall@3x"] forState:UIControlStateNormal];
    [dimisBtn addTarget:self action:@selector(clickdimisBtn) forControlEvents:UIControlEventTouchUpInside];
    [dimisBtn sizeToFit];
    dimisBtn.frame = CGRectMake(YBSSCREEN_WIDTH - dimisBtn.bounds.size.width - kStatusH, kStatusH, dimisBtn.bounds.size.width, dimisBtn.bounds.size.height);
    [self.view addSubview:dimisBtn];
    
}


#pragma mark - Click Action - 点击活动

// 点击了拍照按钮
- (void)clickTakeImageBtn{
    
    AVCaptureConnection *vConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    vConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;// AVCaptureVideoOrientationLandscapeRight;//控制输出照片方向
    
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:vConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return ;
        }
        
        __block UIImage *image;

        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        image = [UIImage imageWithData:imageData];
        NSLog(@"image = %@",image);
        
        CGRect rect1 = [self transfromRectWithImageSize:image.size];
        UIGraphicsBeginImageContext(rect1.size);
        CGImageRef subImgeRef = CGImageCreateWithImageInRect(image.CGImage, rect1);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, rect1, subImgeRef);
        image = [UIImage imageWithCGImage:subImgeRef];
        UIGraphicsEndImageContext();
        UIGraphicsBeginImageContext(rect1.size);
        if (self.ybs_getImageSuccessBlock) self.ybs_getImageSuccessBlock(image);

        [self clickdimisBtn];
    }];
}


// 点击了开灯
- (void)clickLightBtn:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (btn.selected && device.torchMode == AVCaptureTorchModeOff) {
        //闪光灯开启
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        
    }else{
        //闪光灯关闭
        [device setTorchMode:AVCaptureTorchModeOff];
    }
}

// 点击了消失按钮
- (void)clickdimisBtn{
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:true completion:^{
        [weakSelf stopSession];
    }];
}


#pragma mark - Other Action

// 返回扫描框的位置
- (CGRect)makeScanReaderInterrestRect{
    
    // YYBS -> 需要根据横竖屏 来 返回坐标
    
    // 暂时只只只做了 横屏下的显示
    CGFloat x = (YBSSCREEN_WIDTH - self.ybs_scanSize.width) * 0.5;
    CGFloat Y = (YBSSCREEN_HEIGHT - self.ybs_scanSize.height) * 0.5;
    // CGRectMake(YBSScalingStyle(48), YBSScalingStyle(334), YBSScalingStyle(654), YBSScalingStyle(410)); -> 如果在某个机型上 裁剪出现问题 用这些数据试试
    return  CGRectMake(x, Y, self.ybs_scanSize.width, self.ybs_scanSize.height);
}


- (AVCaptureDevice *)cameraWithDirection:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

// 配置默认扫描框
- (CGSize)ybs_scanSize{
    
    if (!_ybs_scanSize.width || !_ybs_scanSize.height) {
        CGFloat x = (YBSSCREEN_WIDTH * vertical_X_SCREEN_WIDTH_proportion > 24)? 24 : YBSSCREEN_WIDTH * vertical_X_SCREEN_WIDTH_proportion;
        _ybs_scanSize = CGSizeMake(YBSSCREEN_WIDTH - 2 * x, (YBSSCREEN_WIDTH - 2 * x) * 0.63044112); // 身份证实际宽高比 为 0.63044112 
    }
    return _ybs_scanSize;
}

-(dispatch_queue_t)queue {
    if (_queue == nil) {
//        _queue = dispatch_queue_create("AVCaptureSession_Start_Running_Queue", DISPATCH_QUEUE_SERIAL);
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    return _queue;
}

/// session开始，即输入设备和输出设备开始数据传递
- (void)runSession {
    if (![self.captureSession isRunning]) {
        dispatch_async(self.queue, ^{
            [self.captureSession startRunning];
        });
    }
}

/// session停止，即输入设备和输出设备结束数据传递
-(void)stopSession {
    if ([self.captureSession isRunning]) {
        dispatch_async(self.queue, ^{
            [self.captureSession stopRunning];
        });
    }
}


/*
 比例剪切照片
 */
- (CGRect)transfromRectWithImageSize:(CGSize)size {
    CGRect newRect;
    CGRect clipRect = [self makeScanReaderInterrestRect];
    
    //相框宽高
    CGFloat  clipWidth = clipRect.size.width;
    CGFloat  clipHeigth = clipRect.size.height;
    //原图宽高
    CGFloat  imageH = size.height;
    CGFloat  imageW = size.width;
    
    NSLog(@"imageH = %f__imageW = %f___YBSSCREEN_HEIGHT = %f___%f",imageH,imageW,YBSSCREEN_HEIGHT,YBSSCREEN_WIDTH );
    
    //bounds
    CGFloat  vpLayerW = YBSSCREEN_WIDTH; // self.bounds.size.width;
    CGFloat  vpLayerH = YBSSCREEN_HEIGHT; // self.bounds.size.height;
    
    // CGRectMake(YBSScalingStyle(48), YBSScalingStyle(334), YBSScalingStyle(654), YBSScalingStyle(410));
     newRect.size = CGSizeMake( (imageH * clipHeigth / vpLayerH)*1.35,(imageW * clipWidth/ vpLayerW)/1.8);
//    newRect.size = CGSizeMake( (imageH * clipHeigth / vpLayerH)*(YBSSCREEN_HEIGHT / self.ybs_scanSize.width),(imageW * clipWidth/ vpLayerW)/(YBSSCREEN_WIDTH / self.ybs_scanSize.height));
    

     newRect.origin = CGPointMake((imageW - newRect.size.width)/2.78, (imageH - newRect.size.height)/2);
//    newRect.origin = CGPointMake((imageW - newRect.size.width)/2, (imageH - newRect.size.height)/2);
    
    return newRect;
}




- (void)dealloc{
    
    NSLog(@"全屏拍照消失了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}




@end
