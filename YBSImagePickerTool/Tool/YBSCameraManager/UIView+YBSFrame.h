//
//  UIView+YBSFrame.h
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/4/26.
//  Copyright © 2018年 严兵胜. All rights reserved.
//

#import <UIKit/UIKit.h>


/**  尺寸 */
#define YBSSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define YBSSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/**  获取状态栏高度 */
#define kYBSStatusH  MIN([UIApplication sharedApplication].statusBarFrame.size.height, [UIApplication sharedApplication].statusBarFrame.size.width)


@interface UIView (YBSFrame)

@property (nonatomic) CGFloat ybs_left; ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat ybs_top; ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat ybs_right; ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat ybs_bottom; ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat ybs_width; ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat ybs_height; ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat ybs_centerX; ///< Shortcut for center.x
@property (nonatomic) CGFloat ybs_centerY; ///< Shortcut for center.y
@property (nonatomic) CGPoint ybs_origin; ///< Shortcut for frame.origin.
@property (nonatomic) CGSize ybs_size; ///< Shortcut for frame.size.

@end
