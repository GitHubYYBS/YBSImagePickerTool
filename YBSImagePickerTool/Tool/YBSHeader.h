//
//  YBSHeader.h
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/4/25.
//  Copyright © 2018年 严兵胜. All rights reserved.
//

#ifndef YBSHeader_h
#define YBSHeader_h

/**  尺寸 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)







/** 自定义打印Log */
#ifdef DEBUG
#define YBSLog(...) printf(" %s\n",[[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#define YBS_CURRENT_METHOD FSXLog(@"%@-%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#else
#define YBSLog(...) ;
#define YBS_CURRENT_METHOD ;

#endif /* FSX_pch */


/**  控件或控制器销毁打印 */
#define YBSLogClassDealloc YBSLog(@"%s_%@_控制器销毁了", __func__,[self class])

#endif /* YBSHeader_h */
