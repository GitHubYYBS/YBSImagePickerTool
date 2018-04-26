//
//  YBSlertActionStyleSheet.h
//  FSX
//
//  Created by moocking－ios on 17/5/12.
//  Copyright © 2017年 严兵胜. All rights reserved.
//

/**
 
 说明: 1.0 相机访问的 子工具类  不对外使用
 
 */

#import <UIKit/UIKit.h>
@class YBSlertActionStyleSheet;
@protocol YBSlertActionStyleSheetDalegate <NSObject>

@optional
- (void)ybsAlertController:(YBSlertActionStyleSheet *)alertController didClickAlertAction:(UIButton *)alertAction;

@end



// 底部钻出
@interface YBSlertActionStyleSheet : UIView


@property (nonatomic, weak) id delegate;


+ (void)ybs_AlertActionStyleSheetDelegate:(id<YBSlertActionStyleSheetDalegate>)delegate titileStr:(NSString *)titleStr  message:(NSString *)message otherTitles:(NSString*)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
