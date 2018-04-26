//
//  YBSDImagePickerTool.h
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/4/25.
//  Copyright © 2018年 严兵胜. All rights reserved.
//



/**
 
 说明: 1.0 该工具类包含了访问相机 及 相册的功能 包括访问权限的查询 如果用户上次作出了拒绝访问的决定 此次将会进入到一个界面 引导我们的用户进行访问权限的设置
 2.0 该类是一个静态常量 即使我们将该类初始化之后 仍可以通过 类方法来获得图片
 
 3.新增可以直接访问 相册 或者 相机的api
 
 4.新增-相机相册访问相册 相机权限api
 */

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>

@interface YBSImagePickerTool : NSObject

/// 默认为No，如果设置为YES,用户将可以选择视频
@property (nonatomic, assign) BOOL ybs_allowPickingVideo;
/// 允许裁剪,默认为YES，只有在单选模式下才生效 多选模式下一律不允许裁剪
@property (nonatomic, assign) BOOL ybs_allowCrop;
/// 选择相机拍照后 是否需要裁剪 默认为No 裁剪尺寸与 ybs_cropRect ybs_needCircleCrop ybs_circleCropRadius 保持一致
@property (nonatomic, assign) BOOL ybs_allowCropTake_a_picture;
/// 裁剪框的尺寸 默认裁剪框尺寸为 300 * 300 且在屏幕的中心位置
@property (nonatomic, assign) CGRect ybs_cropRect;
/// 需要圆形裁剪框
@property (nonatomic, assign) BOOL ybs_needCircleCrop;
/// 圆形裁剪框半径大小
@property (nonatomic, assign) NSInteger ybs_circleCropRadius;



/**
 获得图片__会有底部选显卡弹出(选择图片来源相机还是相册)
 
 @param maxImagesCount 本次最多选择几张
 @param finishPickingPhotos 完成图片选择后回调
 @param failure 图片选择失败的回调
 */
+ (void)ybs_ImagePickerToolWithMaxImagesCount:(NSInteger )maxImagesCount didFinishPickingPhotos:(void(^)(NSArray *imagesArray))finishPickingPhotos failure:(void(^)(NSString *errorStr))failure;

- (void)ybs_ImagePickerToolWithMaxImagesCount:(NSInteger )maxImagesCount didFinishPickingPhotos:(void(^)(NSArray *imagesArray))finishPickingPhotos failure:(void(^)(NSString *errorStr))failure;



/**
 直接调用_相机_获得图片
 
 @param finishPickingPhotos 完成图片选择后回调
 @param failure 失败回调
 */
+ (void)ybs_getImageFromeCameraDidFinishPickingPhotos:(void(^)(NSArray *imagesArray))finishPickingPhotos failure:(void(^)(NSString *errorStr))failure;

- (void)ybs_getImageFromeCameraDidFinishPickingPhotos:(void(^)(NSArray *imagesArray))finishPickingPhotos failure:(void(^)(NSString *errorStr))failure;



/**
 直接调用_相册_获得图片
 
 @param maxImagesCount 本次最多选择几张
 @param finishPickingPhotos 完成图片选择后回调
 @param failure 失败回调
 */
+ (void)ybs_getIamageFromePhotoWithMaxImagesCount:(NSInteger )maxImagesCount didFinishPickingPhotos:(void(^)(NSArray *imagesArray))finishPickingPhotos failure:(void(^)(NSString *errorStr))failure;

- (void)ybs_getImageFromePhotoWithMaxImagesCount:(NSInteger )maxImagesCount didFinishPickingPhotos:(void(^)(NSArray *imagesArray))finishPickingPhotos failure:(void(^)(NSString *errorStr))failure;








/// 相机权限 yes - 允许访问
+ (void)ybs_cameraPermissionResult:(void(^)(BOOL resultBool))resultBlock;


/// 相册权限 yes - 允许访问
+ (void)ybs_PhonePermissionResult:(void(^)(BOOL resultBool))resultBlock;



@end
