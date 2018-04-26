//
//  YBSCameraManager.h
//  照相机demo
//
//  Created by Jason on 11/1/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol YBSCameraManagerDelegate <NSObject>
@optional
- (void)cameraDidFinishFocus;
- (void)cameraDidStareFocus;
@end
@interface YBSCameraManager : NSObject
@property (nonatomic,assign) id<YBSCameraManagerDelegate>delegate;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,assign) BOOL canFaceRecognition;//default is No ,是否可以对焦人脸；
@property (nonatomic,copy) void (^faceRecognitonCallBack)(CGRect);
- (instancetype)initWithParentView:(UIView *)view;
- (void)setFaceRecognitonCallBack:(void (^)(CGRect faceFrame))faceRecognitonCallBack;
/**
 *  添加摄像范围到View
 *
 *  @param parent 传进来的parent的大小，就是摄像范围的大小
 */
- (void)configureWithParentLayer:(UIView *)parent;
/**
 *  切换前后镜
 *
 
 */
- (void)switchCamera:(BOOL)isFrontCamera didFinishChanceBlock:(void(^)())block;
/**
 *  拍照
 *
 *  @param block 原图 比例图 裁剪图 （原图是你照相机摄像头能拍出来的大小，比例图是按照原图的比例去缩小一倍，裁剪图是你设置好的摄像范围的图片）
 */
- (void)takePhotoWithImageBlock:(void(^)(UIImage *originImage,UIImage *scaledImage,UIImage *croppedImage))block;
/**
 *  切换闪光灯模式
 *
 */
- (void)switchFlashMode:(UIButton*)sender;
/**
 *  点击对焦
 *
 */
- (void)focusInPoint:(CGPoint)devicePoint;

/**
 *  开启对焦监听 默认YES
 *
 */
- (void)setFocusObserver:(BOOL)yes;
@end
