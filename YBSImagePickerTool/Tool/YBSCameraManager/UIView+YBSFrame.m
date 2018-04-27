//
//  UIView+YBSFrame.m
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/4/26.
//  Copyright © 2018年 严兵胜. All rights reserved.
//

#import "UIView+YBSFrame.h"

@implementation UIView (YBSFrame)

- (CGFloat)ybs_left
{
    return self.frame.origin.x;
}

- (void)setYbs_left:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)ybs_top
{
    return self.frame.origin.y;
}

- (void)setYbs_top:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)ybs_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setYbs_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ybs_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setYbs_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)ybs_width
{
    return self.frame.size.width;
}

- (void)setYbs_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)ybs_height
{
    return self.frame.size.height;
}

- (void)setYbs_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)ybs_centerX
{
    return self.center.x;
}

- (void)setYbs_centerX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)ybs_centerY
{
    return self.center.y;
}

- (void)setYbs_centerY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)ybs_origin
{
    return self.frame.origin;
}

- (void)setYbs_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)ybs_size
{
    return self.frame.size;
}

- (void)setYbs_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


@end
