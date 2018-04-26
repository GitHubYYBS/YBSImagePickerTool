//
//  YBSBobbleTool.h
//  XiaoGeChuXing
//
//  Created by 严兵胜 on 2018/4/21.
//  Copyright © 2018年 陈樟权. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BUBBLE_Y_LOCATION){
    /// @brief 从屏幕顶端显示
    BUBBLE_Y_LOCATION_Y_0 = 0,
    /// @brief 从状态栏下方显示
    BUBBLE_Y_LOCATION_Y_20 = 1,
    /// @brief 从导航栏下方显示
    BUBBLE_Y_LOCATION_Y_64 = 2,
    /// @brief 从tabBar上方显示
    BUBBLE_Y_LOCATION_Y_TABBAR_TOP = 3,
    /// @brief 从屏幕底部显示
    BUBBLE_Y_LOCATION_Y_TABBAR_DOWN = 4,
};

@interface YBSBobbleTool : UIView

@property (nonatomic, assign)BUBBLE_Y_LOCATION bubblelocationStyle;

/**
 * 单利化
 */
+ (instancetype)sharedBobbleTool;
#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 动画图片+文字_成功提示 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
/**
 * 请求成功_在中间弹窗提示动画图片_默认提示文字:"请求成功" 显示1.5秒
 */
+ (void)showSuccess;
/**
 请求成功_在中间弹窗提示动画图片__提示文字:参数传入_默认1.5秒后消失
 
 @param titile         要提示的标题
 */
+ (void)showSuccessWithTitle:(NSString *)titile;

/**
 请求成功_在中间弹窗提示动画图片_参数:提示语 显示时间:参数传入
 
 @param title         要提示的标题
 @param time          显示的时间
 */

#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓  纯文字提示_在某个位置上显示一个长条文字 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
/**
 纯文字提示_提示文字:参数传入 显示时间:参数传入 显示位置:枚举
 
 @param title         要提示的标题
 @param autoCloseTime 持续时间
 */
+ (void)showOnlyTextWithTitle:(NSString *)title autoCloseTime: (CGFloat)autoCloseTime titleLocationStyle:(BUBBLE_Y_LOCATION)titleLocationStyle;

+ (void)showSuccessWithTitle:(NSString *)titile autoCloseTime:(CGFloat)time;

#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓  动画图片+文字_正在加载ing(太极圈) ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
/**
 加载ing_中间弹窗显示太极圈圈动画图片_图上字下_参数:提示语
 
 @param titile         要提示的标题
 */
+ (void)showRoundProgressWithTitle:(NSString *)titile;

#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓  动画图片+文字_错误提示 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

/**
 * 请求失败_中间弹窗显示动画图片_默认提示文字:"请求失败" 显示1.5秒
 */
+ (void)showError;

/**
 错误提示_中间弹窗显示动画图片_提示文字:参数传入_默认1.5秒显示
 
 @param title         要提示的标题
 */
+ (void)showErrorWithTitle: (NSString *)title;

/**
 错误提示_中间弹窗显示动画图片_提示文字:参数传入 显示时间:参数传入
 
 @param title         要提示的标题
 @param autoCloseTime 持续时间
 */
+ (void)showErrorWithTitle: (NSString *)title autoCloseTime: (CGFloat)autoCloseTime;

#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 隐藏 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
/**
 隐藏提示控件
 */
+ (void)dismiss;

@end
