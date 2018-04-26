//
//  UIViewController+TopViewController.h
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/4/25.
//  Copyright © 2018年 严兵胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TopViewController)

/// 获取目前在栈顶的控制器
- (UIViewController *)ybs_topViewController;

@end
