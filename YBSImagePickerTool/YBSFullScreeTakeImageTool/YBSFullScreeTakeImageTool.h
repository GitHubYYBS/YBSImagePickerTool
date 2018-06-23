//
//  YBSFullScreeTakeImageTool.h
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/5/2.
//  Copyright © 2018年 严兵胜. All rights reserved.
//  全屏拍照或者指定区域拍照 比如 我们给身份证拍照 等  

#import <UIKit/UIKit.h>



typedef void(^YBSGetImageSuccessBlock)(UIImage *image); // 获取到照片

typedef void(^YBSGetImageFailureBlock)(NSString *errorStr); // 失败的block

@interface YBSFullScreeTakeImageTool : UIViewController

/// 扫描尺寸 默认尺寸建议使用默认尺寸宽高比是按照身份证实际宽高比设计的  无论是横屏还是竖屏 其扫描 框始终是在屏幕的中心位置
@property (nonatomic, assign) CGSize ybs_scanSize;

/// 获取到照片后会主动调用该block
@property (nonatomic, copy) YBSGetImageSuccessBlock ybs_getImageSuccessBlock;
/// 拍照失败的回调
@property (nonatomic, copy) YBSGetImageFailureBlock ybs_getImageFailureBlock;








/**
 
 api
 
 */


/**
 开始拍照

 @param finishPickingPhotosBlock 获取到照片
 @param failure 失败回调
 */
+ (void)ybs_fullScreeTakeImageToolidFinishPickingPhotos:(YBSGetImageSuccessBlock)finishPickingPhotosBlock failure:(YBSGetImageFailureBlock)failure;
- (void)ybs_fullScreeTakeImageToolidFinishPickingPhotos:(YBSGetImageSuccessBlock)finishPickingPhotosBlock failure:(YBSGetImageFailureBlock)failure;
@end
