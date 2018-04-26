//
//  YBSBubbleView.h
//  LemonKit
//
//  Created by 严兵胜 on 16/8/30.
//  Copyright © 2016年 严兵胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBSBubbleInfo.h"

/**
 *  @author 严兵胜 LiuRi
 *  @date 2016-08-30 14:08:50
 *
 *  @brief YBS提示系列 - YBS泡泡控件
 */
@interface YBSBubbleView : UIView

/// @brief 进度属性
@property (nonatomic) CGFloat progress;

/**
 *  @author 严兵胜 LiuRi
 *  @date 2016-08-30 16:08:41
 *
 *  @brief 默认的YBS泡泡控件 - 单例方法
 *
 *  @return 默认的YBS泡泡控件对象
 */
+ (YBSBubbleView *)defaultBubbleView;


/**
 注册泡泡信息对象

 @param info 泡泡信息对象
 @param key  泡泡信息对象对应的键
 */
- (void)registerInfo: (YBSBubbleInfo *)info forKey: (NSString *)key;

/**
 *  @author 严兵胜 LiuRi
 *  @date 2016-08-30 16:08:53
 *
 *  @brief 显示指定的信息模型对应的泡泡控件
 */
- (void)showWithInfo: (YBSBubbleInfo *)info;

/**
 *  @author 严兵胜 LiuRi
 *  @date 2016-08-30 16:08:53
 *
 *  @brief 通过传入键来显示已经注册的指定样式泡泡控件
 */
- (void)showWithInfoKey: (NSString *)infoKey;

/**
 *  @author 严兵胜 LiuRi
 *  @date 2016-08-30 16:08:53
 *
 *  @brief 显示指定的信息模型对应的泡泡控件，并指定的时间后隐藏
 *
 *  @param info          样式信息模型
 *  @param time 指定时间后隐藏泡泡控件的秒数
 */
- (void)showWithInfo: (YBSBubbleInfo *)info autoCloseTime: (CGFloat)time;

/**
 *  @author 严兵胜 LiuRi
 *  @date 2016-08-30 16:08:53
 *
 *  @brief 显示指定的信息模型对应的泡泡控件，并指定的时间后隐藏
 *
 *  @param infoKey          已注册的样式信息模型的键
 *  @param time             指定时间后隐藏泡泡控件的秒数
 */
- (void)showWithInfoKey: (NSString *)infoKey autoCloseTime: (CGFloat)time;

/**
 *  @author 严兵胜 LiuRi
 *  @date 2016-08-30 16:08:40
 *
 *  @brief 隐藏当前泡泡控件
 */
- (void)hide;

@end
