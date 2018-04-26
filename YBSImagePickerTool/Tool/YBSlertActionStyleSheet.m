//
//  YBSlertActionStyleSheet.m
//  FSX
//
//  Created by moocking－ios on 17/5/12.
//  Copyright © 2017年 严兵胜. All rights reserved.
//

#import "YBSlertActionStyleSheet.h"
#import "YBSHeader.h"
#import "UIView+Frame.h"


@interface YBSlertActionStyleSheet ()

@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIButton *preBtn;
@property (nonatomic, weak) UIButton *canceBtn;
@property (nonatomic, assign) NSInteger preTag;
@end


static YBSlertActionStyleSheet *ybslertActionStyleSheet;

static CGFloat btnH = 50;
static CGFloat baseSpace = 1;
static CGFloat canceSpace = 10;

@implementation YBSlertActionStyleSheet

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ((ybslertActionStyleSheet = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])) {
        ybslertActionStyleSheet.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        UIButton *bagBtn = [[UIButton alloc] initWithFrame:ybslertActionStyleSheet.bounds];
        [bagBtn addTarget:ybslertActionStyleSheet action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [ybslertActionStyleSheet addSubview:bagBtn];
        
    }
    return ybslertActionStyleSheet;
}


+ (void)ybs_AlertActionStyleSheetDelegate:(id<YBSlertActionStyleSheetDalegate>)delegate titileStr:(NSString *)titleStr  message:(NSString *)message otherTitles:(NSString*)otherTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
    
    if (ybslertActionStyleSheet == nil) {
        ybslertActionStyleSheet = [[YBSlertActionStyleSheet alloc] init];
        ybslertActionStyleSheet.delegate = delegate;
        ybslertActionStyleSheet.preTag = 1;
    }

    
    
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,ybslertActionStyleSheet.preTag * btnH)];
    bottonView.backgroundColor = [UIColor whiteColor];
    [ybslertActionStyleSheet addSubview:ybslertActionStyleSheet.bottomView = bottonView];
    
    BOOL isPhoneX = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO);
    CGFloat bottomSpace = isPhoneX? 34 : 0;
    UIButton *canceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,bottonView.bounds.size.height - btnH - bottomSpace, bottonView.bounds.size.width, btnH)];
    canceBtn.backgroundColor = [UIColor whiteColor];
    canceBtn.tag = ybslertActionStyleSheet.preTag;
    ybslertActionStyleSheet.preTag += 1;
    [canceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canceBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceBtn addTarget:ybslertActionStyleSheet action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
    [bottonView addSubview:ybslertActionStyleSheet.preBtn = ybslertActionStyleSheet.canceBtn = canceBtn];
    
    CGRect preFrame = bottonView.frame;
    preFrame.size.height += canceSpace;
    bottonView.frame = preFrame;
    
    
    NSString* curStr;
    va_list list;
    if (otherTitles) {
        [ybslertActionStyleSheet addBtnBagViewbtnTitle:otherTitles];
        va_start(list, otherTitles);
        while ((curStr = va_arg(list, NSString*))) {
            [ybslertActionStyleSheet addBtnBagViewbtnTitle:curStr];
        }
        va_end(list);
    }

    [ybslertActionStyleSheet show];
    
}

#pragma mark - Click Action
- (void)clickActionBtn:(UIButton *)btn{
    
    YBSLog(@"点击了___btn.titleLabel.text = %@",btn.titleLabel.text)
    
    if ([ybslertActionStyleSheet.delegate respondsToSelector:@selector(ybsAlertController:didClickAlertAction:)]) {
        [ybslertActionStyleSheet.delegate ybsAlertController:ybslertActionStyleSheet didClickAlertAction:btn];
    }
    
    [ybslertActionStyleSheet dismis];
    
}


#pragma mark - Other Action

- (void)addBtnBagViewbtnTitle:(NSString *)btnTitle{
    
    CGRect preFrame = _bottomView.frame;
    preFrame.size.height += btnH + baseSpace;
    _bottomView.frame = preFrame;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.bottomView.bounds.size.height - self.preTag * btnH - (self.preTag - 1) * baseSpace - canceSpace , _bottomView.bounds.size.width, btnH)];
    btn.backgroundColor = _preBtn.backgroundColor;
    [btn setTitleColor:self.preBtn.titleLabel.textColor forState:UIControlStateNormal];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_preBtn = btn];
    
    self.canceBtn.bottom = _bottomView.height;
}

- (void)show{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:ybslertActionStyleSheet];

    [UIView animateWithDuration:0.3 animations:^{
        ybslertActionStyleSheet.bottomView.bottom = SCREEN_HEIGHT;
    }];
}


- (void)dismis{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        ybslertActionStyleSheet.bottomView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        ybslertActionStyleSheet = nil;
    }];
  
    
}

- (void)dealloc{
    
    YBSLogClassDealloc
}
    

@end
