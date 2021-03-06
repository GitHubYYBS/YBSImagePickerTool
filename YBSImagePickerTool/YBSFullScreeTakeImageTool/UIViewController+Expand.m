//
//  UIViewController+Expand.m
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/5/3.
//  Copyright © 2018年 严兵胜. All rights reserved.
//

#import "UIViewController+Expand.h"

@implementation UIViewController (Expand)

- (UIViewController *)ybs_topViewController
{
    return [self topViewControllerWithRootViewController:self];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
        
    }
    else if (rootViewController.presentedViewController)
    {
        
        return [self topViewControllerWithRootViewController:rootViewController.presentedViewController];
        
    }
    else
    {
        return rootViewController;
    }
}


@end
