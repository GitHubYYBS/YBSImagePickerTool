//
//  YBSBobbleTool.m
//  XiaoGeChuXing
//
//  Created by 严兵胜 on 2018/4/21.
//  Copyright © 2018年 陈樟权. All rights reserved.
//

#import "YBSBobbleTool.h"


#import "YBSBubble.h"



/**  获取状态栏高度 */
#define kYBSStatusH  MIN([UIApplication sharedApplication].statusBarFrame.size.height, [UIApplication sharedApplication].statusBarFrame.size.width)
/** 设备是否为iPhone X 分辨率375x812，像素1125x2436，@3x */
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

static YBSBobbleTool *_instance;

@interface YBSBobbleTool ()
@property (nonatomic, assign)CGFloat bubbleHeight;
@end


@implementation YBSBobbleTool


#pragma mark - Simple Interest

+ (instancetype)sharedBobbleTool{
    
    return [[self alloc] init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

-(nonnull id)copyWithZone:(nullable NSZone *)zone
{
    
    return _instance;
}

-(nonnull id)mutableCopyWithZone:(nullable NSZone *)zone
{
    return _instance;
}

#pragma mark - Public Methods
+ (void)showSuccess{
    
    [[self sharedBobbleTool] ybs_howSuccessWithTitle:@"请求成功" autoCloseTime:1.5];
}

+ (void)showSuccessWithTitle:(NSString *)titile{
    
    [[self sharedBobbleTool] ybs_howSuccessWithTitle:titile autoCloseTime:1.5];
}

+ (void)showSuccessWithTitle:(NSString *)titile autoCloseTime:(CGFloat)time{
    
    [[self sharedBobbleTool] ybs_howSuccessWithTitle:titile autoCloseTime:time];
}

+ (void)showOnlyTextWithTitle:(NSString *)title autoCloseTime: (CGFloat)autoCloseTime titleLocationStyle:(BUBBLE_Y_LOCATION)titleLocationStyle{
    
    [[self sharedBobbleTool] ybs_showOnlyTextWithTitle:title autoCloseTime:autoCloseTime titleLocationStyle:titleLocationStyle];
}

+ (void)showRoundProgressWithTitle:(NSString *)titile{
    
    [[self sharedBobbleTool] ybs_showRoundProgressWithTitle:titile];
}

+ (void)showError{
    
    [[self sharedBobbleTool] ybs_showErrorWithTitle:@"请求失败" autoCloseTime:1.5];
}

+ (void)showErrorWithTitle:(NSString *)title{
    
    [[self sharedBobbleTool] ybs_showErrorWithTitle:title autoCloseTime:1.5];
}

+ (void)showErrorWithTitle:(NSString *)title autoCloseTime:(CGFloat)autoCloseTime{
    
    [[self sharedBobbleTool] ybs_showErrorWithTitle:title autoCloseTime:autoCloseTime];
}


+ (void)dismiss{
    
    [[self sharedBobbleTool] dismiss];
}
#pragma mark - Private Methods

// 成功提示
- (void)ybs_howSuccessWithTitle:(NSString *)titile autoCloseTime:(CGFloat)time{
    
    [self showSuccessWithTitle:titile autoCloseTime:time];
}

// 加载ing
- (void)ybs_showRoundProgressWithTitle: (NSString *)title{
    
    [self showRoundProgressWithTitle:title];
}

// 错误提示
- (void)ybs_showErrorWithTitle: (NSString *)title autoCloseTime: (CGFloat)autoCloseTime{
    
    YBSBubbleInfo *info = [self getDefaultErrorBubbleInfo];
    info.title = title;
    [[YBSBubbleView defaultBubbleView] showWithInfo: info autoCloseTime: autoCloseTime];
}

// 纯文字长条显示_y = 0 H = 64
- (void)ybs_showOnlyTextWithTitle:(NSString *)title autoCloseTime: (CGFloat)autoCloseTime titleLocationStyle:(BUBBLE_Y_LOCATION)titleLocationStyle{
    
    YBSBubbleInfo *info = [[YBSBubbleInfo alloc] init];
    info.locationStyle = (titleLocationStyle == BUBBLE_Y_LOCATION_Y_TABBAR_TOP || titleLocationStyle == BUBBLE_Y_LOCATION_Y_TABBAR_DOWN)? BUBBLE_LOCATION_STYLE_BOTTOM : BUBBLE_LOCATION_STYLE_TOP;
    info.title = title;
    info.layoutStyle = BUBBLE_LAYOUT_STYLE_TITLE_ONLY;
    info.isShowMaskView = true;
    info.iconArray = @[[[UIImage alloc] init]];
    info.backgroundColor = [UIColor colorWithRed:93/255.0f green:156/255.0f blue:244/255.0f alpha:1.0];
    info.titleColor = [UIColor whiteColor];
    info.cornerRadius = 0;
    
    // 判断类型 赋值偏移量
    switch (titleLocationStyle) {
        case BUBBLE_Y_LOCATION_Y_0:
            info.proportionOfDistance = 0;
            _bubbleHeight = kYBSStatusH + 44;
            break;
            
        case BUBBLE_Y_LOCATION_Y_20:
            info.proportionOfDistance = 20;
            break;
            
        case BUBBLE_Y_LOCATION_Y_64:
            info.proportionOfDistance = kYBSStatusH + 44;
            break;
            
        case BUBBLE_Y_LOCATION_Y_TABBAR_TOP:
            info.proportionOfDistance = -49;
            break;
            
        case BUBBLE_Y_LOCATION_Y_TABBAR_DOWN:
            info.proportionOfDistance = 0;
            _bubbleHeight = 49;
            break;
        default:
            break;
    }
    _bubbleHeight = _bubbleHeight? _bubbleHeight : 35.0;
    info.bubbleSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _bubbleHeight);
    [[YBSBubbleView defaultBubbleView] showWithInfo: info autoCloseTime: autoCloseTime];
}

// 隐藏现有的提示控件
- (void)dismiss{
    
    [self hideBubble];
}

- (void)dealloc{
    
    NSLog(@"%s_%@_控制器销毁了", __func__,[self class]);
}


@end
