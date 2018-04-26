//
//  YBSBubbleInfo.m
//  LemonKit
//
//  Created by 严兵胜 on 16/9/12.
//  Copyright © 2016年 严兵胜. All rights reserved.
//

#import "YBSBubbleInfo.h"

#define KOneTitleText_H 15.513672 // 该数据由字体的大小决定 若提示字体发生改变,该数据也要发生改变_打印得出

@implementation YBSBubbleInfo

- (instancetype)init{
    self = [super init];
    if (self) {
        self.bubbleSize = CGSizeMake(180, 120);
        self.cornerRadius = 8;
        self.layoutStyle = BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM;
        self.iconAnimation = nil;
        self.onProgressChanged = nil;
        self->_iconArray = nil;
        self->_title = @"请初始化提示语";
        self.frameAnimationTime = 0.1;
        self.proportionOfIcon = 0.675;
        self.proportionOfSpace = 0.1;
        self.proportionOfPadding = CGPointMake(0.1, 0.1);
        self.locationStyle = BUBBLE_LOCATION_STYLE_CENTER;
        self.proportionOfDeviation = 0;
        self.isShowMaskView = YES;
        self->_maskColor = [UIColor colorWithRed: 0.1 green: 0.1 blue:0.1 alpha:0.2];
        self->_backgroundColor = [UIColor colorWithRed: 0  green: 0 blue: 0 alpha: 0.8];
        self->_iconColor = [UIColor whiteColor];
        self->_titleColor = [UIColor whiteColor];
        self.titleFontSize = 13;
        
        // 生成随机的key
        self->_key = arc4random();
    }
    return self;
}

- (instancetype)initWithTitle: (NSString *)title icon: (UIImage *)icon{
    self = [self init];
    if (self) {
        self->_title = title;
        self->_iconArray = @[icon];
    }
    return self;
}

// 提示框的Frame
- (CGRect)calBubbleViewFrame{
    CGFloat y;
    switch (self.locationStyle) {
        case BUBBLE_LOCATION_STYLE_TOP:
            y = 0;
            break;
        case BUBBLE_LOCATION_STYLE_CENTER:
            y = ([UIScreen mainScreen].bounds.size.height - self.bubbleSize.height) / 2;
            break;
        default:
            y = [UIScreen mainScreen].bounds.size.height - self.bubbleSize.height;
            break;
    }
    y += (self.locationStyle != BUBBLE_LOCATION_STYLE_BOTTOM ? 1 : -1) * (self.proportionOfDeviation * [UIScreen mainScreen].bounds.size.height);
    
    y += self.proportionOfDistance? self.proportionOfDistance : 0;
    
    return CGRectMake(([UIScreen mainScreen].bounds.size.width - self.bubbleSize.width) / 2, y, self.bubbleSize.width, self.bubbleSize.height);
}

- (CGRect)calIconViewFrame{
    CGSize bubbleContentSize = CGSizeMake(self.bubbleSize.width * (1 - self.proportionOfPadding.x * 2),
                                          self.bubbleSize.height * (1 - self.proportionOfPadding.y * 2));
    CGFloat baseX = self.bubbleSize.width * self.proportionOfPadding.x;
    CGFloat baseY = self.bubbleSize.height * self.proportionOfPadding.y;
    
    CGFloat iconWidth = self.layoutStyle == BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM || self.layoutStyle == BUBBLE_LAYOUT_STYLE_ICON_ONLY || self.layoutStyle == BUBBLE_LAYOUT_STYLE_ICON_BOTTOM_TITLE_TOP ?
    bubbleContentSize.height * self.proportionOfIcon :
    bubbleContentSize.height * self.proportionOfIcon;
    
    CGRect iconFrame = CGRectMake(baseX, baseY+ (bubbleContentSize.height - iconWidth) / 2, iconWidth, iconWidth);
    switch (self.layoutStyle) {
        case BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM:
            iconFrame.origin.x += (bubbleContentSize.width - iconWidth) / 2;
            iconFrame.origin.y = baseY;
            break;
        case BUBBLE_LAYOUT_STYLE_ICON_BOTTOM_TITLE_TOP:
            iconFrame.origin.x += (bubbleContentSize.width - iconWidth) / 2;
            iconFrame.origin.y = baseY + bubbleContentSize.height - iconWidth;
            break;
        case BUBBLE_LAYOUT_STYLE_ICON_RIGHT_TITLE_LEFT:
            iconFrame.origin.x += bubbleContentSize.width - iconWidth;
            break;
        case BUBBLE_LAYOUT_STYLE_TITLE_ONLY:
            iconFrame = CGRectMake(0, 0, 0, 0);
            break;
        case BUBBLE_LAYOUT_STYLE_ICON_ONLY:
            iconFrame.origin.x += (bubbleContentSize.width - iconWidth) / 2;
            break;
        default:
            break;
    }
    return iconFrame;
}

- (CGRect)calTitleViewFrame{
    CGRect iconFrame = [self calIconViewFrame];
    CGSize bubbleContentSize = CGSizeMake(self.bubbleSize.width * (1 - self.proportionOfPadding.x * 2),
                                          self.bubbleSize.height * (1 - self.proportionOfPadding.y * 2));
    CGFloat baseX = self.bubbleSize.width * self.proportionOfPadding.x;
    CGFloat baseY = self.bubbleSize.height * self.proportionOfPadding.y;
    
    CGFloat titleWidth = self.layoutStyle == BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM || self.layoutStyle == BUBBLE_LAYOUT_STYLE_ICON_BOTTOM_TITLE_TOP || self.layoutStyle == BUBBLE_LAYOUT_STYLE_TITLE_ONLY ?
    bubbleContentSize.width:
    bubbleContentSize.width * (1 - self.proportionOfSpace) - iconFrame.size.width;
    
    CGSize titileTextMaxSize = CGSizeMake(titleWidth, MAXFLOAT);
    CGFloat titleHeight = [self.title boundingRectWithSize:titileTextMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.titleFontSize]} context:nil].size.height;
    
    // 打印得出文字只有一行是的高度是15.513672_调整高度暂时只对显示在中间的弹窗起作用
    if (self.locationStyle == BUBBLE_LOCATION_STYLE_CENTER && titleHeight / KOneTitleText_H > 1) {
        // 调整提示框的 宽 高 _ 目前只调整了提示框的高度,宽度在这里未做调整
        NSInteger timesNum = titleHeight / KOneTitleText_H ; // 除掉第一行的高度,增加其他行的高度
        CGSize bubbleSize = self.bubbleSize;
        bubbleSize.height += timesNum * KOneTitleText_H;;
        self.bubbleSize = bubbleSize;
    }
    
    CGRect titleFrame = CGRectMake(baseX, baseY + (bubbleContentSize.height - titleHeight) / 2, titleWidth, titleHeight);
    
    // 根据不同显示位置类型_调整Y值或X值
    switch (self.layoutStyle) {
        case BUBBLE_LAYOUT_STYLE_ICON_TOP_TITLE_BOTTOM:
            titleFrame.origin.y = iconFrame.origin.y + iconFrame.size.height + bubbleContentSize.height * self.proportionOfSpace;
            break;
        case BUBBLE_LAYOUT_STYLE_ICON_LEFT_TITLE_RIGHT:
            titleFrame.origin.x = iconFrame.origin.x + iconFrame.size.width + bubbleContentSize.width * self.proportionOfSpace;
            break;
        case BUBBLE_LAYOUT_STYLE_ICON_ONLY:
            titleFrame = CGRectMake(0, 0, 0, 0);
            break;
        case BUBBLE_LAYOUT_STYLE_ICON_BOTTOM_TITLE_TOP:
            titleFrame.origin.y = baseY + (bubbleContentSize.height * (1 - self.proportionOfIcon - self.proportionOfSpace) - titleHeight) / 2;
            break;
        default:
            break;
    }
    return titleFrame;
}

@end
